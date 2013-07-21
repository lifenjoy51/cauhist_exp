<%@ tag language="java" pageEncoding="UTF-8"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE HTML>
<html lang='ko'>
<head>
<meta charset='utf-8'>
<title>중앙대 역사학과 답사정보</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name='viewport' content='width=device-width, initial-scale=1.0'>
<meta name='description' content='dictionary for cau historian'>
<meta name='author' content='lifenjoys'>

<!-- Le styles -->
<link href='/resources/css/bootstrap.css' rel='stylesheet'>
<link href='/resources/css/bootstrap-arrows.css' rel='stylesheet'>
<link href='/resources/css/bootstrap-responsive.css' rel='stylesheet'>
<link href='/resources/css/datepicker.css' rel='stylesheet'>
<link href='/resources/css/pagination.css' rel='stylesheet'>

<style type="text/css">
@import url("/resources/css/lifenjoys.css");
</style>

<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
      <script src='/resources/js/html5.js'></script>
    <![endif]-->
</head>

<body>

	<div class='navbar navbar-inverse navbar-fixed-top'>
		<div class='navbar-inner'>
			<div class='container'>
				<a class='btn btn-navbar' data-toggle='collapse'
					data-target='.nav-collapse'> <span class='icon-bar'></span> <span
					class='icon-bar'></span> <span class='icon-bar'></span>
				</a> <a class='brand' href='/'><i
					class="icon-home icon-white"></i> Main</a>

				<div class='nav-collapse'>
					<ul class='nav'>
						<li class='active'><a href='/exp/expInfo'>답사</a></li>
						<li class='active'><a href='/exp/siteInfo'>답사코스</a></li>
						<li class='active'><a href='/exp/expSiteMapping'>답사-코스 연결</a></li>
						<li class='active'><a href='/exp/heritageInfo'>문화유산</a></li>
						<li class='active'><a href='/exp/textInfo'>답사원고</a></li>
						<li class='active'><a href='/resources/info.pdf'>사용안내</a></li>
						<li class='active'><a href='http://assistu.cafe24.com/forum.do'>게시판</a></li>
					</ul>
				</div>
				<!--/.nav-collapse -->
			</div>
		</div>
	</div>

	<div class='container'>

		<jsp:doBody />

		<hr>
		<footer style="text-align: center;">
			<p>lifenjoys</p>
		</footer>

	</div>

	<!-- Le javascript
    ================================================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<script src='/resources/js/jquery.js'></script>
	<script src='/resources/js/jquery.validate.js'></script>
	<script src='/resources/js/jquery.validate.ko.js'></script>
	<script src='/resources/js/bootstrap/bootstrap-transition.js'></script>
	<script src='/resources/js/bootstrap/bootstrap-alert.js'></script>
	<script src='/resources/js/bootstrap/bootstrap-modal.js'></script>
	<script src='/resources/js/bootstrap/bootstrap-dropdown.js'></script>
	<script src='/resources/js/bootstrap/bootstrap-scrollspy.js'></script>
	<script src='/resources/js/bootstrap/bootstrap-tab.js'></script>
	<script src='/resources/js/bootstrap/bootstrap-tooltip.js'></script>
	<script src='/resources/js/bootstrap/bootstrap-popover.js'></script>
	<script src='/resources/js/bootstrap/bootstrap-button.js'></script>
	<script src='/resources/js/bootstrap/bootstrap-collapse.js'></script>
	<script src='/resources/js/bootstrap/bootstrap-carousel.js'></script>
	<script src='/resources/js/bootstrap/bootstrap-typeahead.js'></script>
	<script src='/resources/js/bootstrap/bootstrap-arrows.js'></script>
	<script src='/resources/js/bootstrap/bootstrap-datepicker.js'></script>
	<script src='/resources/js/jquery.pagination.js'></script>
	<script src='/resources/js/common.js'></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$('.arrow, [class^=arrow-]').bootstrapArrows(); //bootstrap-arrow 초기화
		});
	</script>
</body>
</html>