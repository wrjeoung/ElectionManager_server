<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="com.address.DBBean" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<html>
<head>
<title>사업 및 정책</title>
<style type="text/css">
.Padding {
	padding:10px 0 10px 20px;
	height:"auto";
	word-break:break-all;"
}
.Padding2 {
	padding-top:10px; 
	padding-bottom:10px;
	height:"auto";
	word-break:break-all;"
}
</style>
</head>
<%
	System.out.println("{Call BusinessInfoDetial}"); 
	
	int bnSeq = Integer.parseInt(request.getParameter("bn_seq"));
	
	String title = "";
	String kind = "";
	String ctArea = "";
	String summary = "";
	String content = "";
	String progressProcess = "";
	String result = "";
	String etc = "";
	String imgYn = "";
	ArrayList<String> imgList = new ArrayList<String>();
		
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	DBBean dbbean = new DBBean();
	conn = dbbean.getConnection();
	conn.setAutoCommit(false);
	pstmt = null;
	rs = null;
	
	String sql = " SELECT TITLE,BKNAME AS KIND,CT_AREA,SUMMARY,CONTENT,PROGRESS_PROCESS,RESULT,ETC" 
			    +" FROM BUSINESS A,BUSINESS_KIND B WHERE BN_SEQ=?" 
			    +" AND A.KIND=B.BKCODE";
	
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, bnSeq); 
	
	rs = pstmt.executeQuery();
	
	while(rs.next()){
		
		title = rs.getString("TITLE");
		kind = rs.getString("KIND");
		ctArea = rs.getString("CT_AREA");
		summary = rs.getString("SUMMARY");
		content = rs.getString("CONTENT");
		progressProcess = rs.getString("PROGRESS_PROCESS");
		result = rs.getString("RESULT");
		etc = rs.getString("ETC");
				
		System.out.println("title:"+title);
		System.out.println("kind:"+kind);
		System.out.println("ctArea:"+ctArea);
		System.out.println("summary:"+summary);
		System.out.println("content:"+content);
		System.out.println("progressProcess:"+progressProcess);
		System.out.println("result:"+result);
		System.out.println("etc:"+etc);

	}
	
	String ctAreas[] = ctArea.split("/");
	ctArea = "";
	
	sql = "SELECT HAENGTEXT FROM ADM_CODE WHERE ADM_CD = ?";
	pstmt = conn.prepareStatement(sql);
	
	for(int i = 0; i<ctAreas.length;i++) {
		pstmt.clearParameters();
		pstmt.setString(1,ctAreas[i]); 
		
		rs = pstmt.executeQuery();
		if(rs.next()) {
			ctArea += rs.getString("HAENGTEXT");	
		}
		
		if(i < ctAreas.length -1) {
			ctArea += "/";
		}
	}
			
	String summarys[] = summary.split("\n");
	String contents[] = content.split("\n");
	String progressProcesses[] = progressProcess.split("\n");
	String results[] = result.split("\n");
	String etcs[] = etc.split("\n");
	
	
	sql = "SELECT IMG_URL from BUSINESS_IMG WHERE BN_SEQ=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, bnSeq); 
	
	rs = pstmt.executeQuery();
	
	String prefixPath = "./business_upload/";
	
	while(rs.next()) {
		String imgUrl = rs.getString("IMG_URL");
		if(imgUrl != null && !imgUrl.equals("null")) {
			imgList.add(prefixPath+imgUrl);
		}
	}
	
	if(rs!=null) rs.close();
	if(pstmt!=null) pstmt.close();
	if(conn!=null) conn.close();
	
%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js" charset="utf-8"></script>
<body>
<div id="organ">
<div id="div_info">
<table border="0" cellspacing="2"  width="100%" style="table-layout:fixed">
    <tr bgcolor="#f0f0f0"">
        <td width="20%" height="30">
            <p align="center"><b>사업명</b></p>
        </td>
        <td width="80%" valign="middle" class="Padding">
            <p><%=title%></p>
        </td>
    </tr>
    <tr bgcolor="#f6f6f6">
        <td width="20%" height="30" valign="middle" >
            <p align="center"><b>사업종류</b></p>
        </td>
        <td width="80%" valign="middle" class="Padding">
            <p><%=kind%></p>
        </td>
    </tr>
    <tr bgcolor="#f6f6f6">
        <td width="20%" height="30" valign="middle">
            <p align="center"><b>관할지역</b></p>
        </td>
        <td width="80%" valign="middle" class="Padding">
            <p><%=ctArea %></p>
        </td>
    </tr>
    <tr bgcolor="#f6f6f6">
        <td width="20%" height="30" valign="middle">
            <p align="center"><b>사업개요</b></p>
        </td>
        <td width="80%" valign="middle" class="Padding">
        	<% for(int i = 0; i<summarys.length; i++) { %>
            	<%=summarys[i] %><br/>
            <% } %>
        </td>
    </tr>    
    <tr bgcolor="#f6f6f6">
        <td width="20%" height="30" valign="middle">
            <p align="center"><b>주요내용</b></p>
        </td>
        <td width="80%" valign="middle" class="Padding">
        	<% for(int i = 0; i<contents.length; i++) { %>
            	<%=contents[i] %><br/>
            <% } %>
        </td>
    </tr>
    <tr bgcolor="#f6f6f6">
        <td width="20%" height="30" valign="middle">
            <p align="center"><b>진행과정</b></p>
        </td>
        <td width="80%" valign="middle" class="Padding">
        	<% for(int i = 0; i<progressProcesses.length; i++) { %>
            	<%=progressProcesses[i] %><br/>
            <% } %>
        </td>
    </tr>
    <tr bgcolor="#f6f6f6">
        <td width="20%" height="30" valign="middle">
            <p align="center"><b>사업결과</b></p>
        </td>
        <td width="80%" valign="middle" class="Padding">
        	<% for(int i = 0; i<results.length; i++) { %>
            	<%=results[i] %><br/>
            <% } %>
        </td>
    </tr>
    <tr bgcolor="#f6f6f6">
        <td width="20%" height="30" valign="middle">
            <p align="center"><b>기타</b></p>
        </td>
        <td width="80%" valign="middle" class="Padding">
        	<% for(int i = 0; i<etcs.length; i++) { %>
            	<%=etcs[i] %><br/>
            <% } %>
        </td>
    </tr>
    <tr bgcolor="#f6f6f6">
        <td width="100%" height="236" colspan="2 valign="middle" class="Padding2">
       	    <% for(int i = 0; i<imgList.size(); i++) { %>
            	<p align="center"><img src="<%=imgList.get(i) %>" width="280" height="209" border="0"></p>
            <% } %>
        </td>
    </tr>
</table>
</div>
</div>
</body>
</html>