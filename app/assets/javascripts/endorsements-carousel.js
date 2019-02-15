// http://codepen.io/peduarte/pen/bVbZLK
$(document).ready(function() {
  var mountCarousel = function(el) {
    if (!el) return
    var wallop = new Wallop(el);

    var paginationDots = Array.prototype.slice.call(el.querySelectorAll('.Wallop-dot'));

    /*
      Attach click listener on the dots
    */
    paginationDots.forEach(function (dotEl, index) {
      dotEl.addEventListener('click', function() {
        wallop.goTo(index);
      });
    });

    /*
      Listen to wallop change and update classes
    */
    wallop.on('change', function(event) {
      removeClass(el.querySelector('.Wallop-dot--current'), 'Wallop-dot--current');
      addClass(paginationDots[event.detail.currentItemIndex], 'Wallop-dot--current');
    });

    // Helpers
    function addClass(element, className) {
      if (!element) { return; }
      element.className = element.className.replace(/\s+$/gi, '') + ' ' + className;
    }

    function removeClass(element, className) {
      if (!element) { return; }
      element.className = element.className.replace(className, '');
    }

    var nextSlide = setInterval(function () {
      wallop.next();
    }, 8000);

    $(el).on('click', function () {
      clearInterval(nextSlide);
    });
  };

  var endorsementsCarousel = document.querySelector('#endorsements-carousel');
  mountCarousel(endorsementsCarousel);
  var statsCarousel = document.querySelector('#stats-carousel');
  mountCarousel(statsCarousel);
  var ctaCarousel = document.querySelector('#cta-carousel');
  mountCarousel(ctaCarousel);
});
