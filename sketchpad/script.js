/*SKETCHPAD, by Dawn Pattison */

// http://www.theodinproject.com/courses/web-development-101/lessons/javascript-and-jquery



$(document).ready(function(){

	var gridBuilder = function() {

	/* Gets acceptable grid dimensions from user */
	var gridWidth = 17;
	var gridHeight = 17;

	while(gridWidth >16 || gridHeight >16){
		gridWidth = prompt('Enter sketchpad width(1-16): ');
		gridHeight = prompt ('Enter sketchpad height(1-16): ');
	};
	
	/* Builds grid, adds borders, margins */
	for(var i=0; i<gridWidth; i++) {
		for (var j=0; j<gridHeight; j++){
			$('#containerGrid').append("<div class='block'></div>");			
		};
		$('#containerGrid').append("<div class = 'row'> </div>");};
	$('.block').height('25px');
	$('.block').width('25px');
	$('.block').css({
		border:'1px #1E1E2B solid',
		margin: '0px 1px',
		display: 'inline-block'})
	
	};
	gridBuilder()
	
	/* Shades block when mouse passes over */
	
	var blues = ['#0F141A', '#1F2933', '#2E3D4C', '#3D5266', '#4C6680', '#5C7A99', '#6B8FB2', '#7AA3CC', '#8AB8E6', '#99CCFF', '#A3D1FF', '#ADD6FF', '#B8DBFF'];
	
	var randomColor = function(){
		return blues[Math.floor(Math.random() * blues.length)];
	}
	
	$('.block').hover(function(){
		$(this).css('background-color', randomColor());
	
	});

	$('button').click(function(){
		location.reload();
	});
	
	
});