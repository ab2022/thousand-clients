/* ? */

const puppeteer = require("puppeteer-core");
const chromium = require("@sparticuz/chromium");

(async () => {
    try {
        const browser = await puppeteer.launch({
            args: chromium.args,
            defaultViewport: chromium.defaultViewport,
            executablePath: await chromium.executablePath(),
            headless: chromium.headless,
            ignoreHTTPSErrors: true,
        });

        const page = await browser.newPage();

        // Open dash.js.
        //await page.goto("https://www.google.com", { waitUntil: "networkidle0" });
        //await page.goto('https://reference.dashif.org/dash.js/nightly/samples/dash-if-reference-player/index.html');
        await page.goto('http://localhost/player_1.html');

        // Set screen size.
        await page.setViewport({width: 1280, height: 720});

        console.log("Chromium:", await browser.version());
        console.log("Page Title:", await page.title());

        // Click on the Load button.
        //await page.locator('body > div.container > div:nth-child(2) > div.input-group > span > button.btn.btn-primary').click();

        const monitorProgress = setInterval(async () => {
            const progress = await page.evaluate(() => {
                const video = document.querySelector('video');
                if (!video) return null;
                return {
                    currentTime: video.currentTime.toFixed(2),
                    duration: video.duration.toFixed(2),
                    buffering: video.readyState < 3, // READY_STATE < HAVE_FUTURE_DATA
                };
            });

            if (progress) {
                console.log(`Time: ${progress.currentTime} / ${progress.duration} (Buffering: ${progress.buffering})`);
            }

        }, 1000);


        //await page.pdf({path: 'output_page.pdf', printBackground: true});
        //await page.close();
        //await browser.close();
        
        
        //Run the content for 10 seconds and then close the browser.
        setTimeout(() => {
            browser.close();
        }, 60000);
    }
    catch (error) {
        throw new Error(error.message);
    }
})()

