/* eslint-disable @typescript-eslint/no-floating-promises */
process.on(`unhandledRejection`, (reason, promise) => {
    console.error(`Unhandled Rejection reason:`);
    console.error(reason);
    console.error(`Unhandled Rejection at:`);
    console.error(promise);
    process.exit(1);
});
import "lib/polyfill";

if (process.argv[2] === `--upgrade`) {
    import(`fs`).then((fs) => {
        const package_json_path = `package.json`;
        let ext = `bak`;
        let i = 0;
        while (fs.existsSync(`${package_json_path}.${ext}`)) {
            ext = `bak.${i}`;
            i++;
        }
        fs.copyFileSync(package_json_path, `${package_json_path}.${ext}`);
    });
} else console.log(`To upgrade semver or latest dependencies, run 'yarn semver' or 'yarn latest'`);
