import sys
import pandas as pd
import re
from urllib.parse import unquote

ROWS_PER_CHUNK = 10000
logfile = "path/to/logfile.log"

def access(x):
    ua_endpoint = cmcds = None
    D = {}
    """ 3 cases for log lines:
    1) web server log (request mode GET). has both uae and cmcds
    2) web server log (request mode GET). has uae and no cmcds
    3) endpoint log (response/state int. mode POST) no uae and always has cmcds
    """
    try:
        #x[5] ... "5" is the column label written by usecols=[0,5]
        #case 1)
        res = re.search(r'/dash/Service2/(.*)\?CMCD=(.*) ', x[5])
        ua_endpoint = res.group(1)
        cmcds = res.group(2)
    except AttributeError:
        try:
            ua_endpoint = re.search(r'/dash/Service2/(.*) ', x[5]).group(1) #case 2)
        except AttributeError:
            cmcds = re.search(r'CMCD=(.*) ', x[5]).group(1) #case 3)
    if cmcds:
        cmcds = unquote(cmcds)
        A = cmcds.split(',')
        for B in A:
            try:
                k, v = B.split('=', 1)
            except ValueError:
                k = B
                v = True
            D[k] = v
    return pd.Series({'ip': x[0], 'time': x[3][13:], **({'uae': ua_endpoint} if ua_endpoint else {}), **D})


def num_sta_eq_p(F):
    P = F[['sid', 'sta']]
    R_0 = P[P.sta == '"p"'].value_counts()
    R_1 = P[P.sta == '"pl"'].value_counts()
    R = pd.concat([R_0, R_1]).groupby(level=[0]).sum()
    the_plot(R.values, "num of sta='p' or 'pl'", 'sids')


def req_per_sec(F):
    T = pd.to_datetime(F.time, format='mixed')
    U = T.value_counts().sort_index().values
    the_plot(U, 'reqs per sec', 'secs')


def what_type(F):
    #mpd or init (mp4), video (p4v) or audio (p4a) segment
    F['type'] = F['uae'].str[-3:]
    F['type'].value_counts() #over all sids

    H = F[['sid', 'type']].value_counts().reset_index() #per sid
    import matplotlib.pyplot as plt
    #example: distribution of reqs for mpd
    H[H.type == 'mpd'].hist(figsize=(12,8))
    plt.show()


def the_plot(data, lab, xlab):
    import matplotlib.pyplot as plt
    fig = plt.figure(figsize=(12,8))
    ax = fig.add_subplot()
    ax.plot(data, label=lab);
    ax.xaxis.set_ticklabels([])
    ax.set_xlabel(xlab)
    ax.legend()
    plt.show()


def get_data():
    F = pd.DataFrame()
    reader = pd.read_table(logfile, sep=" ", header=None, engine="c", usecols=[0,3,5], chunksize=ROWS_PER_CHUNK, iterator=True)
    i = 0
    for data_chunk in reader:
         processed_chunk = data_chunk.apply(access, axis=1)
         F = pd.concat([F, processed_chunk])
         i = i+1
         print('line {}'.format(i*ROWS_PER_CHUNK))

    return F


if __name__ == '__main__':

    if len(sys.argv) > 1:
        if sys.argv[1] == 'get_data':
            F = get_data()

