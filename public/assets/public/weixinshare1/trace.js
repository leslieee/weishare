﻿(function() {
    if (!document.body) {
        setTimeout(arguments.callee, 50);
        return false
    }
    var sendLogOver = false;
    var version = "1.0";
    window.addedBtn = [];
    var start, end, startX = 0,
    startY = 0,
    temPos, oPosition = {};
    var logPath = "//rcv.iclicash.com/trace";
    var lpNow = now();
    var iclitype = "";
    var isTouch = (window.Modernizr && Modernizr.touch === true) || (function() {
        return !! (("ontouchstart" in window) || window.DocumentTouch && document instanceof DocumentTouch)
    })();
    var clickEvent = isTouch ? "touchend": "mouseup";
    var scr = document.getElementsByTagName("script"),
    auto = 0,
    scrTime = 0,
    noTime = 0;
    for (var i = 0; i < scr.length; i++) {
        if (scr[i].src.indexOf("trace") > 0) {
            scrTime++;
            var traScr = scr[i];
            var autoNum = getQueryString(scr[i].src);
            if (parseInt(autoNum.auto) == 1) {
                noTime++;
                auto = 1
            }
        }
    }
    if (scrTime > 1 && noTime == 1) {
        auto = 0
    }
    var device_detect = (function(ua, platform) {
        var os = this.os = {},
        browser = this.browser = {},
        webkit = ua.match(/Web[kK]it[\/]{0,1}([\d.]+)/),
        android = ua.match(/(Android);?[\s\/]+([\d.]+)?/),
        osx = !!ua.match(/\(Macintosh\; Intel /),
        ipad = ua.match(/(iPad).*OS\s([\d_]+)/),
        ipod = ua.match(/(iPod)(.*OS\s([\d_]+))?/),
        iphone = !ipad && ua.match(/(iPhone\sOS)\s([\d_]+)/),
        webos = ua.match(/(webOS|hpwOS)[\s\/]([\d.]+)/),
        win = /Win\d{2}|Windows/.test(platform),
        wp = ua.match(/Windows Phone ([\d.]+)/),
        touchpad = webos && ua.match(/TouchPad/),
        kindle = ua.match(/Kindle\/([\d.]+)/),
        silk = ua.match(/Silk\/([\d._]+)/),
        blackberry = ua.match(/(BlackBerry).*Version\/([\d.]+)/),
        bb10 = ua.match(/(BB10).*Version\/([\d.]+)/),
        rimtabletos = ua.match(/(RIM\sTablet\sOS)\s([\d.]+)/),
        playbook = ua.match(/PlayBook/),
        chrome = ua.match(/Chrome\/([\d.]+)/) || ua.match(/CriOS\/([\d.]+)/),
        firefox = ua.match(/Firefox\/([\d.]+)/),
        firefoxos = ua.match(/\((?:Mobile|Tablet); rv:([\d.]+)\).*Firefox\/[\d.]+/),
        ie = ua.match(/MSIE\s([\d.]+)/) || ua.match(/Trident\/[\d](?=[^\?]+).*rv:([0-9.].)/),
        webview = !chrome && ua.match(/(iPhone|iPod|iPad).*AppleWebKit(?!.*Safari)/),
        weixin = ua.match(/MicroMessenger/i),
        UC = ua.match(/UCBrowser/i),
        QQ = ua.match(/QQ\//i),
        MI = ua.match(/MiuiBrowser\//i),
        BaiduBox = ua.match(/baiduboxapp\//i),
        safari = webview || ua.match(/Version\/([\d.]+)([^S](Safari)|[^M]*(Mobile)[^S]*(Safari))/);
        if (browser.webkit = !!webkit) {
            browser.version = webkit[1]
        }
        if (android) {
            os.android = true,
            os.version = android[2]
        }
        if (iphone && !ipod) {
            os.ios = os.iphone = true,
            os.version = iphone[2].replace(/_/g, ".")
        }
        if (ipad) {
            os.ios = os.ipad = true,
            os.version = ipad[2].replace(/_/g, ".")
        }
        if (ipod) {
            os.ios = os.ipod = true,
            os.version = ipod[3] ? ipod[3].replace(/_/g, ".") : null
        }
        if (wp) {
            os.wp = true,
            os.version = wp[1]
        }
        if (webos) {
            os.webos = true,
            os.version = webos[2]
        }
        if (touchpad) {
            os.touchpad = true
        }
        if (blackberry) {
            os.blackberry = true,
            os.version = blackberry[2]
        }
        if (bb10) {
            os.bb10 = true,
            os.version = bb10[2]
        }
        if (rimtabletos) {
            os.rimtabletos = true,
            os.version = rimtabletos[2]
        }
        if (playbook) {
            browser.playbook = true
        }
        if (kindle) {
            os.kindle = true,
            os.version = kindle[1]
        }
        if (silk) {
            browser.silk = true,
            browser.version = silk[1]
        }
        if (!silk && os.android && ua.match(/Kindle Fire/)) {
            browser.silk = true
        }
        if (chrome) {
            browser.chrome = true,
            browser.version = chrome[1]
        }
        if (firefox) {
            browser.firefox = true,
            browser.version = firefox[1]
        }
        if (firefoxos) {
            os.firefoxos = true,
            os.version = firefoxos[1]
        }
        if (ie) {
            browser.ie = true,
            browser.version = ie[1]
        }
        if (safari && (osx || os.ios || win)) {
            browser.safari = true;
            if (!os.ios) {
                browser.version = safari[1]
            }
        }
        if (webview) {
            browser.webview = true
        }
        if (weixin) {
            browser.weixin = true
        }
        if (QQ) {
            browser.QQ = true
        }
        if (UC) {
            browser.UC = true
        }
        if (MI) {
            browser.MI = true
        }
        if (BaiduBox) {
            browser.BaiduBox = true
        }
        os.tablet = !!(ipad || playbook || (android && !ua.match(/Mobile/)) || (firefox && ua.match(/Tablet/)) || (ie && !ua.match(/Phone/) && ua.match(/Touch/)));
        os.phone = !!(!os.tablet && !os.ipod && (android || iphone || webos || blackberry || bb10 || (chrome && ua.match(/Android/)) || (chrome && ua.match(/CriOS\/([\d.]+)/)) || (firefox && ua.match(/Mobile/)) || (ie && ua.match(/Touch/))));
        os.version = os.version || "0.0";
        os.PC = (/win/i.test(platform) || /Mac/.test(platform));
        if (os.PC) {
            os.MAC = /Mac/.test(platform);
            os.WIN = /win/i.test(platform)
        }
        return this
    }).call({},
    window.navigator.userAgent, window.navigator.platform);
    var device_orientation = (function(angle) {
        if (angle === 90 || angle == -90) {
            return 1
        } else {
            return 0
        }
    })( + (window.orientation || 0));
    if (self != top) {
        var query = getQueryString(top.location.href)
    } else {
        var query = getQueryString(window.location.href)
    }
    iclitype = query.iclitype;
    if (query.icliwxid || query.icliqqid) {
        var script = document.createElement("script");
        script.src = "//cdn.iclicash.com/trace/wxqqjump.js?v=1";
        document.body.appendChild(script)
    }
    var logParams = {
        iclicashsid: query.iclicashsid ? query.iclicashsid: "none",
        o: device_orientation,
        w: document.documentElement.clientWidth || document.body && document.body.clientWidth,
        h: document.documentElement.clientHeight || document.body && document.body.clientHeight,
        sw: screen.availWidth,
        sh: screen.availHeight,
        os: device_detect.os.MAC ? "MAC": device_detect.os.WIN ? "WIN": device_detect.os.PC ? "pc": device_detect.os.android ? "Android": device_detect.os.ios ? "iOS": "other",
        ref: encodeURIComponent(document.referrer || ""),
        v: version,
        auto: auto == 1 ? "1": "0"
    };
    window.onerror = function(message, url, line, col, e) {
        sendTypeLog({
            t: "error",
            op1: message || "",
            op2: (line || 0) + "," + (col || 0),
            url: url || "",
            op3: ((e || {}).stack || (e || "").toString() || "")
        })
    };
    initialize();
    var timer = setInterval(function() {
        if (sendLogOver) {
            clearInterval(timer);
            return
        }
        sendTypeLog({
            t: "load"
        })
    },
    200);
    function initialize() {
        var _iclicashCache = window._iclicash || [];
        window._iclicash = {
            push: function(args) {
                iclicashMonitor.apply(window, args)
            }
        };
        if (_iclicashCache instanceof Array) {
            _iclicashCache.forEach(window._iclicash.push);
            window._iclicash.push([document.body, clickEvent, "clickMonitor"]); [].forEach.call(document.querySelectorAll("form"),
            function(form, index) {
                window._iclicash.push([form, "submit", "formSubmit", form.action, index])
            }); [].forEach.call(document.querySelectorAll("input[type=text]"),
            function(input, index) {
                window._iclicash.push([input, "focus", "inputFocus", input.name || "none", index])
            }); [].forEach.call(document.querySelectorAll("a, button, input[type=button]"),
            function(button, index) {
                window._iclicash.push([button, "click", "buttonClick", button.name || button.tagName, index])
            });
            isZombie();
            stayMonitor([5, 10, 30, 60, 120])
        }
    }
    function now() {
        return new Date().getTime()
    }
    function getQueryString(url) {
        var theRequest = {};
        var str = url.indexOf("#") > -1 ? url.substring(1 + url.indexOf("?"), url.indexOf("#")) : url.substr(1 + url.indexOf("?"));
        str = str.split("&");
        for (var i = 0; i < str.length; i++) {
            var param = str[i].split("=");
            theRequest[param[0]] = decodeURIComponent(param.slice(1).join("="))
        }
        return theRequest
    }
    function objectExtend(a, b) {
        for (var i in b) {
            if (b.hasOwnProperty((i))) {
                a[i] = b[i]
            }
        }
        return a
    }
    function sendLog(url) {
        var img = document.createElement("img");
        img.src = url;
        img.setAttribute("src", url);
        img.setAttribute("style", "display:none;");
        img.setAttribute("onload", "var p = this.parentNode;p&&p.removeChild(this);");
        setTimeout(function() {
            document.body.appendChild(img)
        },
        0)
    }
    function getScrollTop() {
        return document.body.scrollTop || document.documentElement.scrollTop || 0
    }
    function sendTypeLog(params) {
        if (params.t == "load") {
            sendLogOver = true
        }
        params = objectExtend(params || {},
        logParams);
        params.p = getScrollTop();
        var queryString = [];
        for (var i in params) {
            if (params.hasOwnProperty((i))) {
                params[i] && queryString.push(i + "=" + params[i])
            }
        }
        sendLog(logPath + "?" + queryString.join("&") + "&_t=" + Math.floor((now() - lpNow) / 1000))
    }
    function getFormatEvent(event) {
        event = window.event || event;
        var target = event.target || event.srcElement;
        var point = event.touches && event.touches[0] || event;
        return {
            target: target,
            point: point,
            event: event
        }
    }
    function proxyEvent(name, option1, option2, option3) {
        var params = {
            t: name
        };
        option1 && (params.op1 = option1);
        option2 && (params.op2 = option2);
        option3 && (params.op3 = option3);
        return function(event) {
            var fe = getFormatEvent(event);
            var point = fe.point;
            var times = +fe.target.getAttribute("times") || 0;
            times += 1;
            fe.target.setAttribute("times", times);
            params.s = times;
            if ("clientX" in point) {
                params.x = point.clientX;
                params.y = point.clientY;
                params.px = point.pageX;
                params.py = point.pageY
            } else {
                if (point.changedTouches) {
                    params.x = parseInt(point.changedTouches[0].clientX);
                    params.y = parseInt(point.changedTouches[0].clientY);
                    params.px = parseInt(point.changedTouches[0].pageX);
                    params.py = parseInt(point.changedTouches[0].pageY)
                }
            }
            if (auto) {
                params.auto = auto
            }
            sendTypeLog(params)
        }
    }
    function iclicashMonitor(target, listenEventName, customEventName, option1, option2, option3) {
        if (target) {
            if (target.id) {
                for (var i in window.addedBtn) {
                    if (target.id == window.addedBtn[i].id) {
                        return
                    }
                }
            }
            window.addedBtn.push(target);
            if (target.length) {
                target = target[0]
            }
            if (!target.addEventListener) {
                throw "Incorrect target"
            }
            var eventHandle = proxyEvent(customEventName || listenEventName, option1, option2, option3);
            switch (listenEventName) {
            case "click":
                target.addEventListener("click", eventHandle, true);
                break;
            default:
                target.addEventListener(listenEventName, eventHandle, true)
            }
            target.setAttribute("iclicash_checked", "true")
        }
    }
    function stayMonitor(monitorList) {
        sendTypeLog({
            t: "stay",
            duration: 1
        });
        var monitorCurrent = now();
        var monitor = setInterval(function() {
            if (now() - monitorCurrent > monitorList[0] * 1000) {
                if (auto) {
                    sendTypeLog({
                        t: "stay",
                        auto: auto,
                        duration: monitorList[0]
                    })
                } else {
                    sendTypeLog({
                        t: "stay",
                        duration: monitorList[0]
                    })
                }
                monitorList.shift();
                if (monitorList.length < 1) {
                    clearInterval(monitor);
                    monitor = null
                }
            }
        },
        1000)
    }
    function isZombie() {
        var judge = setTimeout(function() {
            if (getScrollTop() < 1) {
                sendTypeLog({
                    t: "zombie"
                })
            }
        },
        20000);
        window.addEventListener("scroll", clean, true);
        document.body.addEventListener("touchmove", clean, true);
        document.body.addEventListener("mousemove", clean, true);
        function clean() {
            judge && clearTimeout(judge);
            judge = null
        }
    }
    function touchPos(e) {
        var touches = e.changedTouches,
        l = touches.length,
        touch, tagX, tagY;
        for (var i = 0; i < l; i++) {
            touch = touches[i];
            tagX = touch.clientX;
            tagY = touch.clientY
        }
        oPosition.x = tagX;
        oPosition.y = tagY;
        return oPosition
    }
    var status = 0;
    var notSupportPress = false;
    function touchStartFunc(e) {
        var touches = e.changedTouches,
        l = touches.length,
        touch;
        for (var i = 0; i < l; i++) {
            touch = touches[i]
        }
        touchPos(e);
        startX = oPosition.x;
        startY = oPosition.y;
        start = now();
        setTimeout(function() {
            if (status == 0) {
                touchPos(e);
                var moveX = oPosition.x - startX;
                var moveY = oPosition.y - startY;
                end = now();
                var exacTime = end - start;
                if (moveX == 0 && moveY == 0) {
                    if (exacTime >= 500) {
                        if (iclitype == "1") {
                            var params = {
                                t: "press_wx",
                                duration: exacTime,
                                x: parseInt(touch.clientX),
                                y: parseInt(touch.clientY),
                                px: parseInt(touch.pageX),
                                py: parseInt(touch.pageX)
                            };
                            sendTypeLog(params)
                        } else {
                            var params = {
                                t: "press",
                                duration: exacTime,
                                x: parseInt(touch.clientX),
                                y: parseInt(touch.clientY),
                                px: parseInt(touch.pageX),
                                py: parseInt(touch.pageX)
                            };
                            sendTypeLog(params)
                        }
                        notSupportPress = true
                    }
                }
            }
        },
        2000)
    }
    function handler() {
        return false
    }
    function touchEndFunc(e) {
        var touches = e.changedTouches,
        l = touches.length,
        touch;
        for (var i = 0; i < l; i++) {
            touch = touches[i]
        }
        console.log(parseInt(touch.clientX));
        console.log(parseInt(touch.clientY));
        if (notSupportPress) {
            return
        }
        status = 1;
        touchPos(e);
        var moveX = oPosition.x - startX;
        var moveY = oPosition.y - startY;
        end = now();
        var exacTime = end - start;
        if (moveX == 0 && moveY == 0) {
            if (exacTime >= 500) {
                if (iclitype == "1") {
                    var params = {
                        t: "press_wx",
                        duration: exacTime,
                        x: parseInt(touch.clientX),
                        y: parseInt(touch.clientY),
                        px: parseInt(touch.pageX),
                        py: parseInt(touch.pageY)
                    };
                    sendTypeLog(params)
                } else {
                    var params = {
                        t: "press",
                        duration: exacTime,
                        x: parseInt(touch.clientX),
                        y: parseInt(touch.clientY),
                        px: parseInt(touch.pageX),
                        py: parseInt(touch.pageY)
                    };
                    sendTypeLog(params)
                }
                notSupportPress = false
            }
        }
    }
    document.body.addEventListener("touchstart", touchStartFunc, true);
    document.body.addEventListener("touchend", touchEndFunc, true); (function() {
        var targetText = ["免费", "领取", "立即", "下载", "注册", "点击", "提交", "申请", "信息", "领劵", "改善", "购买", "Android", "安卓", "IOS", "苹果"];
        var all = document.getElementsByTagName("*");
        var dom = [];
        for (var i = 0; i < all.length; i++) {
            for (var j in targetText) {
                if (all[i].getAttribute("iclicash_checked")) {
                    break
                }
                if (all[i].innerText.indexOf(targetText[j]) > -1 && all[i].innerText.length < 10) {
                    if (iclitype == "2") {
                        if (all[i].innerText.indexOf("下载") > -1 || all[i].innerText.indexOf("Android") > -1 || all[i].innerText.indexOf("IOS") > -1 || all[i].innerText.indexOf("安卓") > -1 || all[i].innerText.indexOf("苹果") > -1) {
                            window._iclicash = window._iclicash || [];
                            window._iclicash.push([all[i], "click", "active_auto_download", "自动生成的按钮监控：" + (all[i].innerText || all[i].id || "")])
                        }
                    }
                    if (iclitype == "3") {
                        if (all[i].innerText.indexOf("立即") > -1 || all[i].innerText.indexOf("提交") > -1) {
                            window._iclicash = window._iclicash || [];
                            window._iclicash.push([all[i], "click", "active_auto_submit", "自动生成的按钮监控：" + (all[i].innerText || all[i].id || "")])
                        }
                    }
                    window._iclicash = window._iclicash || [];
                    window._iclicash.push([all[i], "click", "active_auto", "自动生成的按钮监控：" + (all[i].innerText || all[i].id || "")]);
                    all[i].setAttribute("iclicash_checked", "true")
                }
            }
        }
    })()
})();