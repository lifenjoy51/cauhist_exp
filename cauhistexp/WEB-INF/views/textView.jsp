<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	pageContext.setAttribute("crlf", "\n");
%>
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

	var galleriaCnt = '${fn:length(textInfos)}'; //겔러리 개수

	$(document).ready(
	function() {
		Galleria.loadTheme('/resources/js/galleria/themes/classic/galleria.classic.min.js');
		var query = '${heritageInfo.heritage_name}';
		fnImgSearch(query);
	});

	/*
	 * 사진검색
	 */
	function fnImgSearch(query) {
		//alert(query);
		//요청
		$.ajax({
			url : "findImgs",
			type : 'post',
			dataType : 'json',
			data : 'query=' + query,
			success : function(json) {
				$("body").append(json)
				Galleria.run('#galleria', {
					dataSource : json.list
				});
			},
		});
	}
</script>

<body>
	<div class="container">

		<div class="page-header">



			<h1>${heritageInfo.heritage_name}</h1>
		</div>
		<c:forEach items="${textInfos}" var="textInfo" varStatus="status">
			<div class="row mb20">
			
			<c:if test="${status.first}">
				<div class="span4">					
						<div id="galleria" class="galleria">
						</div>
				</div>
				<div class="span8">
			</c:if>
			
			<c:if test="${!status.first}">
				<div class="span12">
			</c:if>					
			
					<c:if test="${!status.first}">
						<h2>${textInfo.text_name}</h2>
					</c:if>
					<c:set var="text_content"
						value="${fn:replace(textInfo.text_content,crlf, '<br>')}" />
					<p class="kr06">${text_content}</p>
					<strong class="text-right">${textInfo.author}</strong>
					<p>${textInfo.source}</p>
					
				</div>
			</div>
		</c:forEach>
	</div>
</body>
</html>