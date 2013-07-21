<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title></title>
</head>
<link href='/resources/css/lifenjoys.css' rel='stylesheet'>
<link href='/resources/css/bootstrap.css' rel='stylesheet'>
<link href='/resources/css/bootstrap-responsive.css' rel='stylesheet'>
<link type="text/css" rel="stylesheet"
	href="/resources/js/galleria/themes/classic/galleria.classic.css">
<script src='/resources/js/jquery.js'></script>
<script src="/resources/js/galleria/galleria-1.2.9.js"></script>

<script type="text/javascript">
	var cnt = 0;
	var max = 1000;
	var height = 256;
	var slot = new Array();
	var c;
	var ctx;

	$(document).ready(function() {
		c = document.getElementById("myCanvas");
		ctx = c.getContext("2d");

		setInterval("monitor()", 1000);
		var div = $('#content');
		for ( var i = 0; i < max; i++) {
			div.append($('<p/>', {
				id : 'div' + i
			}));
		}
	});

	/*
	 * 사진검색
	 */
	function monitor() {
		//alert(query);
		//요청
		$.ajax({
			url : "monitor",
			type : 'post',
			dataType : 'json',
			success : function(json) {
				var obj = json["long-array"];
				var total_memory = obj[0];
				var free_memory = obj[1];
				var max_memory = obj[2];
				var used_memory = total_memory - free_memory;
				used_memory = ((used_memory / 1024) / 1024);
				var ptr = (+cnt % max);
				slot[ptr] = used_memory;
				//ctx.fillRect(0, ptr, parseFloat(used_memory / 1024 / 1024), 1);
				ctx.fillStyle = "#6C8CD5";
				ctx.fillRect(ptr, height - used_memory, 1, height);
				ctx.fillStyle = "#FFFFFF";
				ctx.fillRect(ptr - 1, 0, 1, height);
				ctx.fillStyle = "#6C8CD5";
				ctx.fillRect(ptr - 2, height - slot[ptr - 2], 1, height);
				//ctx.fillRect(0, ptr, 20, 1);
				cnt++;
			},
		});
	}
</script>

<body>
	<canvas class="span12" id="myCanvas" width="1000" height="256"
		style="border:1px solid #000000;"> </canvas>
</body>
</html>