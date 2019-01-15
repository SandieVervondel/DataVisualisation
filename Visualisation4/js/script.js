var width = window.innerWidth||document.documentElement.clientWidth||document.body.clientWidth;
var height = window.innerHeight||document.documentElement.clientHeight||document.body.clientHeight;

var svg = d3.select("body").append("svg")
    .attr("height","100%")
    .attr("width","100%")
		.attr("viewbox", "0 0 "+width+" "+height);

// Create gradient for fill of bars 
// Code from: https://www.freshconsulting.com/d3-js-gradients-the-easy-way/
var defs = svg.append("defs");
// Direction
var gradient = defs.append("linearGradient")
   .attr("id", "gradient")
   .attr("x1", "0%")
   .attr("x2", "0%")
   .attr("y1", "0%")
   .attr("y2", "100%");
// Color stops
gradient.append("stop")
   .attr('class', 'start')
   .attr("offset", "0%")
   .attr("stop-color", "green")
   .attr("stop-opacity", 1);
gradient.append("stop")
   .attr('class', 'end')
   .attr("offset", "100%")
   .attr("stop-color", "red")
   .attr("stop-opacity", 1);

// Create a title
svg.append("text")
		.attr("class", "title")
		.attr("x", 50)
		.attr("y", 25).attr("dominant-baseline", "hanging")
		.text("THE DNA OF MANU SPORNY");

// Get the first set of data, the DNA
d3.csv("data/DNA.csv")
	.row(function(d){ return {RS_id: d.RS_id, chromosome: d.Chromosome, position: Number(d.Position.trim()), genotype: d.Genotype};})
	.get(function(error,dna){
	
	// Get the second set of data, the meaning of the RS id's
	d3.csv("data/RS.csv")
		.row(function(d){ return{RS_id: d.RS_id, meaning: d.General_Meaning, posgen: d.Pos_Gen, posmeaning: d.Meaning_Pos, midgen: d.Middle_Gen, midmeaning: d.Meaning_Middle, neggen: d.Neg_Gen, negmeaning: d.Meaning_Neg}})
		.get(function(error, rs){
		
		// Create a group in which we will put all the visualisations, and move them
		var visualisations = svg.append("g").attr("class", "visualisation").attr("transform", "translate("+width*0.55+", 50)");
		
		// Create indivudual groups for each visualisation
		// We're putting this in a variable so we can easily re-use this group for the bars and all the different text items 
		// The opacity is set to 0 so that none of them will be visible untill you select one
		var oneviz = visualisations.selectAll(".oneviz")
			.data(rs)
			.enter().append("g").attr("class", "oneviz").attr("id", function(d){return d.RS_id + "viz"}).style("opacity", 0);
		
		// Some variables for position and height
		var vizHeight = height - 200;
		var startHeight = 60;
		var barX = 65;
		var meaningPos = 130;
		
		// Create an array where only the overlapping rows of both files are stored in
		// Since the DNA file has about 1 million lines, it's interesting to do this only once
		var overlapping = [];
		dna.forEach(function(d1, i){
			rs.forEach(function(d2, j){
				if(d1.RS_id == d2.RS_id){
					var dnaobject = {
						RS_id: d1.RS_id,
						chromosome: d1.chromosome,
						genotype: d1.genotype
					};
					overlapping.push(dnaobject);
				}
			})
		})
		
		// Create a title for the visualisation, containing the RS id and the meaning of that id
		oneviz.each(function(d,i){
			d3.select(this).selectAll(".titleviz")
				.data([d])
				.enter().append("text")
				.attr("class", "titleviz")
				.attr("x", barX)
				.attr("y", 0)
				.attr("text-anchor", "left")
				.attr("dominant-baseline", "middle")
				.text(function(d){ return d.RS_id+": "+d.meaning})})
		
		// Create text that shows on what chromosome this gen can be found
		oneviz.each(function(d,i){
			d3.select(this).selectAll(".chromosome")
				.data([d])
				.enter().append("text")
				.attr("class", "chromosome")
				.attr("x", barX)
				.attr("y", 30)
				.attr("dominant-baseline", "middle")
				.text(function(d){
					var chromosome = "";
					overlapping.forEach(function(d1){
						if(d1.RS_id == d.RS_id){
							chromosome = "Chromosome: " + d1.chromosome;
						}
					})
			return chromosome})})
		
		// Create a bar for each visualisation
		oneviz.each(function(d,i){
			d3.select(this).selectAll(".bar")
				.data([d])
				.enter()
				.append("rect")
				.attr("class", "bar")
				.attr("x", barX)
				.attr("y", startHeight)
				.attr("width", 50)
				.attr("height", vizHeight)
				.attr("fill", "url(#gradient)");
		})
		
		// Create labels with the positive gen, middle gen, negative gen and its meaning for the bars
		// Positive gen
		oneviz.each(function(d,i){
			d3.select(this).selectAll(".posgen")
				.data([d])
				.enter().append("text")
				.attr("class", "posgen")
				.attr("x", 0)
				.attr("y", startHeight)
				.attr("dominant-baseline", "hanging")
				.text(function(d){ return d.posgen})})
		// Middle gen
		oneviz.each(function(d,i){
			d3.select(this).selectAll(".midgen")
				.data([d])
				.enter().append("text")
				.attr("class", "midgen")
				.attr("x", 0)
				.attr("y", (vizHeight+startHeight)/2)
				.attr("dominant-baseline", "middle")
				.text(function(d){ return d.midgen})})
		// Negative gen
		oneviz.each(function(d,i){
			d3.select(this).selectAll(".neggen")
				.data([d])
				.enter().append("text")
				.attr("class", "neggen")
				.attr("x", 0)
				.attr("y", vizHeight+startHeight)
				.text(function(d){ return d.neggen})})
		// If the gen from the DNA file doesn't correspond with any of the predetermined types
		oneviz.each(function(d,i){
			d3.select(this).selectAll(".unknown")
				.data([d])
				.enter().append("text")
				.attr("class", "unknown")
				.attr("x", 0)
				.attr("y", startHeight+(vizHeight/2)/2)
				.attr("dominant-baseline", "middle")
				.text("Other")})
		// Meaning of the positive gen
		oneviz.each(function(d,i){
			d3.select(this).selectAll(".posmean")
				.data([d])
				.enter().append("text")
				.attr("class", "posmean")
				.attr("x", meaningPos)
				.attr("y", startHeight)
				.attr("dominant-baseline", "hanging")
				.text(function(d){ return d.posmeaning})})
		// Meaning of the middle gen
		oneviz.each(function(d,i){
			d3.select(this).selectAll(".midmean")
				.data([d])
				.enter().append("text")
				.attr("class", "midmean")
				.attr("x", meaningPos)
				.attr("y", (vizHeight+startHeight)/2)
				.attr("dominant-baseline", "middle")
				.text(function(d){ return d.midmeaning})})
		// Meaning of the negative gen
		oneviz.each(function(d,i){
			d3.select(this).selectAll(".negmean")
				.data([d])
				.enter().append("text")
				.attr("class", "negmean")
				.attr("x", meaningPos)
				.attr("y", vizHeight+startHeight)
				.text(function(d){ return d.negmeaning})})
		// If the gen from the DNA file doesn't correspond with any of the predetermined types 
		oneviz.each(function(d,i){
			d3.select(this).selectAll(".unknownmean")
				.data([d])
				.enter().append("text")
				.attr("class", "unknownmean")
				.attr("x", meaningPos)
				.attr("y", startHeight+(vizHeight/2)/2)
				.attr("dominant-baseline", "middle")
				.text("Not yet discovered genotype")})
		
		// Draw the line at the correct position according to the overlapping array
		oneviz.each(function(d,i){
			d3.select(this).selectAll("line")
				.data([d])
				.enter().append("line")
				.attr("x1", barX)
				.attr("x2", barX+50)
				.attr("y1", function(d){ 	
						var height = startHeight+(vizHeight/2)/2;
						overlapping.forEach(function(d1){
						if(d1.RS_id == d.RS_id){
							if(d1.genotype == d.posgen){
								height = startHeight;
							}if(d1.genotype == d.midgen){
								height = (vizHeight+startHeight)/2
							}if(d1.genotype == d.neggen){
								height = vizHeight+startHeight
							}
						}
				});return height; })
				.attr("y2", function(d){ 	
						var height = startHeight+(vizHeight/2)/2;
						overlapping.forEach(function(d1){
						if(d1.RS_id == d.RS_id){
							if(d1.genotype == d.posgen){
								height = startHeight;
							}if(d1.genotype == d.midgen){
								height = (vizHeight+startHeight)/2
							}if(d1.genotype == d.neggen){
								height = vizHeight+startHeight
							}
						}
				});return height;})
		})
		
		// Create all the labels to show the visualisations
		var newY = 0;
		svg.append("g").append("text").selectAll("tspan")
		.data(rs)
		.enter().append("tspan")
			// Too much data to put in one column, so at every even index we put the text left, every uneven is put on the right
			.attr("x",function(d,i){ if(i%2 == 0){ return 50}; if(i%2 == 1){return 390}})
			// Everytime the index is even, the row has to change, so we increase the newY values with the index times 25
			// We then divide that value by 2 to make the spacing between each row smaller 
			.attr("y",function(d,i){ if(i%2 == 0){newY = i*25/2; }return 125 + newY})
			.text(function(d){ return d.meaning;})
			.on("mouseover", function() {
				svg.selectAll("tspan").style("fill", null);
        d3.select(this).style("fill", "red");
      })
			.on("click", function(d){
				oneviz.style("opacity",0);
			  d3.select("#"+d.RS_id+"viz").style("opacity",1);
				svg.selectAll("tspan").style("fill", null);
				d3.select(this).style("fill", "blue");
			});
		
	});
	
});