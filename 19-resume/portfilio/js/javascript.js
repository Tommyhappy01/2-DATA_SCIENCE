
//smoot scrollspy
$(document).ready(function () {

  $('body').scrollspy({
    target: "#mainnavbar",
    offset: 51
  }); //scroll spy özelliği

  $("#mainnavbar a").on('click', function (event) { //smoot scroll
    if (this.hash !== "") {

      event.preventDefault();

      var hash = this.hash; // hash leri depola

      $('html, body').animate({ //animate fonk
        scrollTop: $(hash).offset().top-50
      }, 1000, function () {

       // window.location.hash = hash;
      });
    }
  });
});




// SkillBar progress
$('.skills__item').each(function () {
  $(this).find('.skills__progress').animate({
    width: $(this).attr('data-percent')
  }, 3000);
});




//slider team

$('#teamSlider').each(function () {

  var $this = $(this);
  var $group = $this.find('.slide_group');
  var $slides = $this.find('.slide');
  var bulletArray = [];                 // noktalar için
  var currentIndex = 0;                 //
  var timeout;                          //

  function move(newIndex) {
    var animateLeft, slideLeft;

    advance();

    if ($group.is(':animated') || currentIndex === newIndex) { 
      return;
    }

    bulletArray[currentIndex].removeClass('active');
    bulletArray[newIndex].addClass('active');

    if (newIndex > currentIndex) {    //effect
      slideLeft = '100%';
      animateLeft = '-100%';
    } else {
      slideLeft = '-100%';
      animateLeft = '100%';
    }

    $slides.eq(newIndex).css({         //eq:equempment
      display: 'block',
      left: slideLeft
    });

    $group.animate({
      left: animateLeft
    }, function () {
      $slides.eq(currentIndex).css({
        display: 'none'
      });
      $slides.eq(newIndex).css({
        left: 0
      });
      $group.css({
        left: 0
      });
      currentIndex = newIndex;
    });

  }

  function advance() {
    clearTimeout(timeout);
    timeout = setTimeout(function () {
      if (currentIndex < ($slides.length - 1)) {
        move(currentIndex + 1);
      } else {
        move(0);
      }
    }, 3000);
  }

  $('.next_btn').on('click', function () {
    if (currentIndex < ($slides.length - 1)) {
      move(currentIndex + 1);
    } else {
      move(0);
    }
  });

  $('.previous_btn').on('click', function () {
    if (currentIndex !== 0) {
      move(currentIndex - 1);
    } else {
      move(3);
    }
  });

  $.each($slides, function (index) {                    // nokta üret
    var $button = $('<a class="slide_btn">&bull;</a>');

    if (index === currentIndex) {
      $button.addClass('active');                 //ilk slayt için varsayılan aktif gösterim
    }

    $button.on('click', function () {
      move(index);
    }).appendTo('.slide_buttons');

    bulletArray.push($button);
  });

  advance();
});
