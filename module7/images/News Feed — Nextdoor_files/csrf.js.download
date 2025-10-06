/** @fileoverview This contains js for the send csrf token header on ajax requests */

(function($) {
  if ($ && !$.csrf_applied) {
    var absoluteUrlPattern = /^https?:\/\//i;

    // Always send non-GET ajax requests with CSRF tokens for local requests
    $.ajaxPrefilter(function(options, originalOptions, jqXHR) {
      var urlIsAbsolute = absoluteUrlPattern.test(options.url); // assume remote if absolute
      if (options.type.toUpperCase() !== 'GET' && !urlIsAbsolute) {
        options.headers = $.extend({'X-CSRFTOKEN': window.CSRFTOKEN}, originalOptions.headers);
      }
    });

    $.csrf_applied = true;
  }
})(window && window.jQuery);
