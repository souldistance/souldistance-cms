<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/resource/js/jquery-3.2.1.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/resource/js/jquery.validate.js"></script>
<script type="text/javascript" src="/resource/js/bootstrap.js"></script>
<link href="/resource/css/bootstrap.css" rel="stylesheet"
	type="text/css">
<link href="<%=request.getContextPath()%>/resource/css/cms.css"
	rel="stylesheet" type="text/css">
<script type="text/javascript">
	$(function() {
		$("#title").html("“" + '${article.title }' + "”");
	})
	function collect() {
		var text = '${article.title }';
		var url = location.href;
		$
				.ajax({
					url : "/index/article/collect",
					data : {
						text : text,
						url : url
					},
					type : "post",
					success : function(flag) {
						if (flag.code == 0) {
							alert("收藏成功!");
							$("#login").html(" ");
							$("#collect")
									.html(
											"<span style='color: red;font-size: 18px;'>★已收藏</span>");
						} else {
							alert(flag.message);
							$("#login")
									.html(
											"<button type='button' class='btn btn-info' onclick='tologin()'>登录</button>");
						}
					},
					error : function() {
						alert("系统错误!");
					}
				})
	}
	function back() {
		location = "/";
	}
</script>
</head>
<body>
	<div class="container">
		<div class="jumbotron jumbotron-fluid">
			<div class="container container-sm">
				<h1 class="display-4">${article.title }</h1>
				<p class="lead">
					<fmt:formatDate value="${article.created }"
						pattern="yyyy-MM-dd HH:mm:ss" />
					<span style="padding-left: 20px">点击量: ${article.hits }</span>
				</p>
				<p class="lead">
					发布人 · <span>${article.user.username }</span>
				</p>
			</div>
		</div>
		<hr>
		<div style="float: left;" id="collect">
			<c:if test="${collect!=null }">
				<span style="color: red; font-size: 18px;">★已收藏</span>
			</c:if>
			<c:if test="${collect==null }">
				<a href="#" onclick="collect()"><span style="font-size: 18px;">☆收藏</span></a>
				<div id="login" style="float: left;"></div>
			</c:if>
		</div>
		<div style="text-align: right;">
			<button type="button" class="btn btn-dark" onclick="back()">返回</button>
		</div>
		<div id="carouselExampleCaptions" class="carousel slide"
			data-ride="carousel" data-interval="3000"
			style="width: 50%; margin: 0 auto; clear: both;">
			<ol class="carousel-indicators">
				<c:forEach items="${pictures}" var="a" varStatus="i">
					<li data-target="#carouselExampleCaptions"
						data-slide-to="${i.index }" class="${i.index==0?"active":"" }"></li>
				</c:forEach>
			</ol>
			<div class="carousel-inner">
				<c:forEach items="${pictures }" varStatus="i" var="picture">
					<div class="carousel-item ${i.index==0?"active":"" }">
						<img src="/pic/${picture.url}" alt="${picture.desc }"
							style="width: 100%; height: 300px;">
						<div class="carousel-caption d-none d-md-block">
							<h5>${picture.desc }</h5>

						</div>
					</div>
				</c:forEach>
			</div>
			<a class="carousel-control-prev" href="#carouselExampleCaptions"
				role="button" data-slide="prev"> <span
				class="carousel-control-prev-icon" aria-hidden="true"></span> <span
				class="sr-only">Previous</span>
			</a> <a class="carousel-control-next" href="#carouselExampleCaptions"
				role="button" data-slide="next"> <span
				class="carousel-control-next-icon" aria-hidden="true"></span> <span
				class="sr-only">Next</span>
			</a>
		</div>
		<hr />
		<div class="container">
			<h4>最新评论</h4>
		</div>
		<div class="container" id="comments">

			<c:forEach items="${comments}" var="comment">
				<div class="media">
					<div class="media-left">
						<a href="#"> <img class="media-object"
							src="/pic/default_avatar.png" style="max-height: 50px" alt="...">
						</a>
					</div>
					<div class="media-body">
						<h4 class="media-heading">${comment.user.username}：</h4>
						<p>${comment.content}</p>
						<p>
							评论时间：
							<fmt:formatDate value="${comment.created}" pattern="yyyy-MM-dd" />
						</p>
					</div>
				</div>
			</c:forEach>
		</div>
		<div class="container">
			<form id="comment" name="comment" method="post" style="width: 70%">
				<input type="hidden" name="article.id" value="${article.id }">
				<textarea id="content" name="content" cols="3" class="form-control"
					placeholder="${user.username}发表评论"></textarea>
				<button type="submit" class="btn btn-info btn-block">发表</button>
			</form>
		</div>
	</div>
	<script type="text/javascript">
	
		var username = "${user.username}";
		
		var template = "<div class=\"media\">"
		  +"<div class=\"media-left\">"
		  +"<a href=\"#\">"
		  +"<img class=\"media-object\" src=\"/pic/default_avatar.png\" style=\"max-height: 50px\" alt=\"...\">"
		  +"</a>"
		  +"</div>"
		  +"<div class=\"media-body\">"
		  +"<h4 class=\"media-heading\">${user.username}：</h4>"
		  +"<p>{{comment_content}}</p>"
		  +"<p>评论时间：刚刚</p>"
		  +"</div>"
		  +"</div>";
		  
		$(document).ready(function(){
			if(username.length==0){
				$("#content").attr("disabled", "disabled").attr("placeholder", "请登录后发表评论");
			}
			
			$("#comment").submit(function(){
				var content = $("#content").val();
				if(content.length==0){
					alert('请填写评论内容');
					return false;
				}
				
				$.ajax({
					url:'/my/addComment/',
					type:'post',
					data:$(this).serialize(),
					error: function(){alert('发表失败');},
					success:function(data){
						if(data.code==0){
							var comments = $("#comments").html();
							$("#comments").html(template.replace("{{comment_content}}", content) + comments);
							$("#content").val("");
						}else{
							alert(data.message)
						}
					}
					
				},"json");
				return false;
			});
		});
	</script>
</body>
</html>