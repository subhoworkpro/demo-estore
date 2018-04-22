// $('.counter').countUp();


$(document).ready(function() {
    // $(".scroll").click(function(event) {
    //     event.preventDefault();
    //     $('html,body').animate({
    //         scrollTop: $(this.hash).offset().top
    //     }, 1000);
    // });


    // $().UItoTop({
    //     easingType: 'easeOutQuart'
    // });
    $('#horizontalTab').easyResponsiveTabs({
        type: 'default', //Types: default, vertical, accordion           
        width: 'auto', //auto or any width like 600px
        fit: true, // 100% fit in a container
        closed: 'accordion', // Start closed if in accordion view
        activate: function(event) { // Callback function if tab is switched
            console.log("asdsadas");
            var $tab = $(this);
            var $info = $('#tabInfo');
            var $name = $('span', $info);
            $name.text($tab.text());
            $info.show();
        }
    });
 //    $('#verticalTab').easyResponsiveTabs({
 //        type: 'vertical',
 //        width: 'auto',
 //        fit: true
 //    });

    $("#slider3").responsiveSlides({
		auto: true,
		pager: true,
		nav: false,
		speed: 500,
		namespace: "callbacks",
		before: function () {
		$('.events').append("<li>before event fired.</li>");
		},
		after: function () {
			$('.events').append("<li>after event fired.</li>");
		}
	});

    $( "#slider-range" ).slider({
                range: true,
                min: 0,
                max: 9000,
                values: [ 1000, 7000 ],
                slide: function( event, ui ) {  $( "#amount" ).val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
                }
     });
    $( "#amount" ).val( "$" + $( "#slider-range" ).slider( "values", 0 ) + " - $" + $( "#slider-range" ).slider( "values", 1 ) );

    $('.flexslider').flexslider({
        animation: "slide",
        controlNav: "thumbnails"
    });
});