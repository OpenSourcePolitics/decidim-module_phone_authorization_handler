/* eslint-disable multiline-ternary, no-ternary */
// require self

/*
 *
 * This is used to make sure users are redirected to
 * the expected URL after sign in.
 *
 * When a button or link trigger a login modal we capture
 * the event and inject the URL where the user should
 * be redirected after sign in (the redirect_url param).
 *
 * The code is injected to any form or link in the modal
 * and when the modal is closed we remove the injected
 * code.
 *
 * In order for this to work the button or link must have
 * a data-open attribute with the ID of the modal to open
 * and a data-redirect-url attribute with the URL to redirect
 * the user. If any of this is missing no code will be
 * injected.
 *
 */
$((target, options) => {
    const removeUrlParameter = (url, parameter) => {
        const urlParts = url.split("?");

        if (urlParts.length >= 2) {
            // Get first part, and remove from array
            const urlBase = urlParts.shift();

            // Join it back up
            const queryString = urlParts.join("?");

            const prefix = `${encodeURIComponent(parameter)}=`;
            const parts = queryString.split(/[&;]/g);

            // Reverse iteration as may be destructive
            for (let index = parts.length - 1; index >= 0; index -= 1) {
                // Idiom for string.startsWith
                if (parts[index].lastIndexOf(prefix, 0) !== -1) {
                    parts.splice(index, 1);
                }
            }

            if (parts.length === 0) {
                return urlBase;
            }

            return `${urlBase}?${parts.join("&")}`;
        }

        return url;
    }
    const mutationObserver = (selector) => {
        return new Promise((resolve, reject) => {
            // Example from : https://gist.github.com/jwilson8767/db379026efcbd932f64382db4b02853e
            let el = document.querySelector(selector);

            if (el) {resolve(el);}
            new MutationObserver((mutationRecords, observer) => {
                // Query for elements matching the specified selector
                for (let mutation of mutationRecords) {
                    if (mutation.type === "childList" && mutation.addedNodes.length > 0) {
                        for ( let node of mutation.addedNodes ) {
                            if ( node.nodeName === "DIV" ) {
                                resolve($(node).find("a.button.expanded"));
                                // Disable observer
                                observer.disconnect();
                            }
                        }

                    }
                }
            })
                .observe(document.documentElement, {
                    childList: true,
                    subtree: true
                });
        });
    };

    $(document).on("click.zf.trigger", (event) => {
        let target = `#${$(event.target).data("open")}`;
        const redirectUrl = $(event.target).data("redirectUrl");

        if (target && redirectUrl) {
            $("<input type='hidden' />")
                .attr("id", "redirect_url")
                .attr("name", "redirect_url")
                .attr("value", redirectUrl)
                .appendTo(`${target} form`);

            mutationObserver(target).then( (element) => {
                if (element && $(element).attr("href").length > 0) {
                    $(element).attr("href", (index, href) => {
                        href = removeUrlParameter(href, "redirect_url");
                        const querystring = jQuery.param({"redirect_url": redirectUrl});
                        return href + (href.match(/\?/) ? "&" : "?") + querystring;
                    });
                }
            });
        }
    });

    $(document).on("closed.zf.reveal", (event) => {
        $("#redirect_url", event.target).remove();
        $("a", event.target).attr("href", (index, href) => {
            if (href && href.indexOf("redirect_url") !== -1) {
                return removeUrlParameter(href, "redirect_url");
            }

            return href;
        });
    });
});
