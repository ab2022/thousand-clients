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
                k, v = B.split('=')
            except ValueError:
                k = B
                v = True
            D[k] = v
    return pd.Series({'ip': x[0], **({'uae': ua_endpoint} if ua_endpoint else {}), **D})


def num_sta_eq_p(F):
    N = F
    P = N[['sid', 'sta']]
    R = P[P.sta == '"p"'].value_counts().values #R is the ndarray to plot

    import matplotlib.pyplot as plt
    fig = plt.figure(figsize=(12,8))
    ax = fig.add_subplot()
    ax.plot(R, label="num of sta='p'");
    ax.xaxis.set_ticklabels([])
    ax.set_xlabel('sids')
    ax.legend()
    plt.show()


def get_data():
    F = pd.DataFrame()
    reader = pd.read_table(logfile, sep=" ", header=None, engine="c", usecols=[0,5], chunksize=ROWS_PER_CHUNK, iterator=True)
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

