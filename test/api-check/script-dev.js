const uriRegister  = require("./uri-register.js");
const uriRequest  = require("./uri-request.js");
const fs = require("fs");
const BASE_API = "http://194.163.178.42:68";

(async function() {

    if (!fs.existsSync("./scenario")) {
        fs.mkdirSync("./scenario");
    }

    if (process.argv[2]) {
        const file = process.argv[2];
        if (fs.existsSync("./scenario/" + file + "/index.js")) {
            uriRegister.addFunc(file, require("./scenario/" + file + "/index.js"));
        }
    } else {
        console.log("\n \u001b[31mscenario source is require like this:\n \u001b[33m$ node scenario.js create-home-main-menu", "\u001b[0m\n");
    }
    
    const configs = {
        APP_API: BASE_API
    };

    const headers = {
        "content-type": "application/json",
    };

    // user login first to get token;
    try {
        const response = await uriRequest(BASE_API + "/msx-sts/api/domain/v1/auth/login", "POST", headers, {}, null, {
            "email": "0913333960",
            "password": "12345678",
            "system":"care",
            "authType": "local", 
            "deviceToken": "e23kqcuYRFa2XdnKgzSDCp:APA91bH5_WC0iBojQ_M3ZR8ihCY8nHT5Me_433wPcBGWCAZZa4HQRNAcfOnZzC1SYzzDHn4umGrXiKa68u6rx1kreMZUFY_rAK3dxvaij6Y8-cxsEh3JVfVcJccyT7AD0fCf9qD5Uu7a"
        });
        console.log("token", response);
        headers["Authorization"] = `Bearer ${response.access_token}`;
    } catch(e) {

    }

    uriRegister.getAllFunc().forEach(funcName => {
        const func = uriRegister.getFuncByName(funcName);
       
        if (func) {
            try {
                func(uriRequest, configs, headers, funcName);
            } catch(e) {
                console.log("error", funcName);
            }
        }
    });
})();
