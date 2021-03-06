<%-- 
    Document   : Template 2 column
    Created on : Dec 18, 2011, 12:11:32 PM
    Author     : Reshad
--%>

<% session.setAttribute("URL", request.getRequestURL() + "?Category=" + request.getParameter("Category")); %>
<%@page import="java.util.ArrayList"%>
<%@page import="com.catalog.model.Node"%>
<%@page import="com.catalog.model.Tree"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.catalog.model.MySQL"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
//Check if user is admin or moderator
boolean isAdmin = false;
boolean isModerator = false;
try
{
    if(Byte.parseByte((String) session.getAttribute("Type")) >= 9 )
    {
        isAdmin = true;
        isModerator =true;
    }
    if(Byte.parseByte((String) session.getAttribute("Type")) >= 5 )
    {
        isModerator =true;
    }
}
catch(NumberFormatException e)
{
    ;
}
MySQL db = new MySQL();
db.connect();
ResultSet rs = db.executeQuery("SELECT `CategoryName` FROM `category` WHERE `CategoryID` = '" + request.getParameter("Category") + "';");
rs.next();
%>

<html>
    <head>
        <title>
            <%=rs.getString(1) %> - TechE
        </title>
        <%
        if(request.getParameter("Category") == null)
        {
            out.println("<meta http-equiv=\"refresh\" content=\"0; url=index.jsp\">");
        }
        %>
        <!-- Style Sheet Import Starts Here -->
        <link rel="stylesheet" type="text/css" href="Styles/styles.css" />
        <link rel="stylesheet" type="text/css" href="Styles/home.css" />
        <link rel="stylesheet" type="text/css" href="Styles/Menu/ddsmoothmenu.css" />
        <!-- Style Sheet Import Ends Here -->

        <!-- Script Import Starts Here -->
        <script type="text/javascript" src="Scripts/jQuery/jquery-1.6.2.js">
        </script>
        <script type="text/javascript" src="Scripts/Menu/ddsmoothmenu.js">
/***********************************************
* Smooth Navigational Menu- (c) Dynamic Drive DHTML code library (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
***********************************************/
        </script>
        <!-- Script Import Ends Here -->

        <!-- Script Declaration Starts Here -->
        <script type="text/javascript">
ddsmoothmenu.init(
{
mainmenuid: "smoothmenu-ajax",
customtheme: ["#025091", "#007ce7"],//customtheme: ["#1c5a80", "#18374a"], //override default menu CSS background values? Uncomment: ["normal_background", "hover_background"]
contentsource: ["smoothcontainer", "Scripts/Menu/menu.html"] //"markup" or ["container_id", "path_to_menu_file"]
})
        </script>
        <!-- Script Declaration Ends Here -->


    </head>
    <body>

        <div id="wrap">
	
            <!-- Header code starts here -->
            <div id="header">

                <!-- Logo code starts here -->
                <div id="Logo">
                    <a href="index.jsp">
                    <img src="Images/Logos/TechE Logo.png" height="100" />
                    </a>
                </div>
		<!-- Logo code ends here -->
                
                <!-- Login code starts here -->
		<div id="Login">
                    <jsp:include page="hidden/Login.jsp"></jsp:include>
                </div>
                <!-- Login code ends here -->
	
            </div>
            <!-- Header code ends here -->
	
            <!-- Navigation menu code starts here -->
            <div id="nav" >
                <div id="smoothcontainer">
                    <noscript>
                    <a href="smoothmenu.html">Site map</a>
                    </noscript>
                </div>
            </div>
            <!-- Navigation menu code ends here -->
        
	
            <!-- Left colum starts here -->
            <div id="left">
                
                
                <%
                int pageNo;
                
                //Build Tree object for categories
                Tree tree = new Tree();
                                
                ResultSet result = db.executeQuery("SELECT `CategoryID`,`ParentCategoryID`,`CategoryName` FROM `category`;");
                //skip root as it already is part of Tree class
                result.next();
                while(result.next())
                {
                    tree.addNode(new Node(result.getString(1), result.getString(2), result.getString(3)));
                    
                    if(result.getString(1).equals(request.getParameter("Category")))
                    {
                        out.println("<h1>" + result.getString(3) + "</h1>");
                    }
                        
                }
                
                
                if(request.getParameter("Page") != null)
                {
                    pageNo=Integer.parseInt(request.getParameter("Page"));
                }
                else
                {
                    pageNo=0;
                }
                
                
                ArrayList<Node> children = tree.getChildren(request.getParameter("Category"));
                String whereClauze="";
                for(int i=0;i<children.size();i++)
                {
                    whereClauze += " OR `item`.`CategoryID` = '" + children.get(i).getNodeID() + "' "; 
                }
                //System.out.println("SELECT `ItemID`, `CategoryID`, `ItemName` FROM `Catalog`.`Item` WHERE `Item`.`CategoryID` = '" + request.getParameter("Category") +"' "+ whereClauze + " ORDER BY `TimeStamp` DESC LIMIT " + (pageNo*5) + ", " + 5 + ";");
                result = db.executeQuery("SELECT `ItemID`, `CategoryID`, `ItemName` FROM `item` WHERE `CategoryID` = '" + request.getParameter("Category") +"' "+ whereClauze + " ORDER BY `TimeStamp` DESC LIMIT " + (pageNo*5) + ", " + 5 + ";");
                while(result.next())
                {
                    %>
                    <div id="item-<%= result.getString(1) %>" class="ItemBox">
                        <div id="HeaderLine">
                            <div id="ItemName">
                                <br/> <br/>
                                <a href="Item.jsp?ItemID=<%=result.getString(1) %>">
                                    <%= result.getString(3) %>
                                </a>
                            </div>
                            <div id="CategoryPath">
                                <%
                                ArrayList<Node> l= tree.getParentNodes(result.getString(2));
                                for(int i=0;i<l.size();i++)
                                {
                                    out.println("<a href=\"Categories.jsp?Category=" + l.get(i).getNodeID() + "\">" + l.get(i).getData() + "</a>");
                                    if(i != l.size()-1)
                                    {
                                        out.print(" > ");
                                    }
                                }
                                %>
                            </div>
                        </div>
                        <div id="BodyArea">
                            <div id="ItemImage">
                                <%
                                MySQL itemDetailsdb=new MySQL();
                                itemDetailsdb.connect();
                                String itemID=result.getString(1);
                                String itemName=result.getString(3);
                                ResultSet itemDetails=itemDetailsdb.executeQuery("SELECT `Detail`, `Value` FROM `itemdetails` WHERE `ItemID` = '" + result.getString(1) + "' LIMIT 7");
                                itemDetails.next();
                                if(itemDetails.getString(2).equals("NoFile"))
                                {
                                    %>
                                    <img src="Images/Items/NoImage.jpeg" />
                                    <%
                                }
                                else
                                {
                                %>
                                <img src="Images/Items/Item-<%=itemID %>/<%=itemDetails.getString(2) %>" />
                                <%
                                }
                                %>
                            </div>
                            <div id="ItemDetails">
                                <%
                                while(itemDetails.next())
                                {
                                    try
                                    {
                                        %>
                                        <div class="Detail">
                                            <%=itemDetails.getString(1) %>: &nbsp;
                                        </div>
                                        <div class="Value">
                                            <%=itemDetails.getString(2) %>
                                        </div>
                                        <br/>
                                        <%
                                    }
                                    catch(Exception e)
                                    {
                                        out.print("exception");
                                    }
                                }
                                itemDetailsdb.disconnect();
                                %>
                            </div>
                        </div>
                        <div id="Footer">
                            <div id="rating">
                                <!-- 5 star rating code here -->
                            </div>
                            <table>
                                <tr>
                                    <!-- facebook buttons start here -->
                                    <td>
                                        <iframe src="//www.facebook.com/plugins/like.php?href=http%3A%2F%2Fteche.tk%2FItem.jsp%3FItemID%3D<%=itemID %>&amp;send=false&amp;layout=button_count&amp;width=300&amp;show_faces=false&amp;action=like&amp;colorscheme=light&amp;font&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:100px; height:20px;" allowTransparency="true"></iframe>
                                        <!-- <iframe src="http://www.facebook.com/plugins/like.php?href=patuck.net&amp;layout=button_count&amp;show_faces=false&amp;width=300&amp;action=like&amp;font=lucida+grande&amp;colorscheme=light&amp;height=80" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:100px; height:20px;" allowTransparency="true"></iframe> -->
                                    </td> 
                                    <!-- facebook buttons end here -->
                                    <!-- twitter button start here -->
                                    <td>
                                        <a href="https://twitter.com/share" class="twitter-share-button" data-url="http://teche.tk/Item.jsp?ItemID=<%=itemID %>" data-text="Check out the <%=itemName %> at TechE -">Tweet</a>
                                        <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
                                        <!-- <a href="http://twitter.com/share" class="twitter-share-button" data-count="horizontal">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script> -->
                                    </td>
                                    <!-- twitter button end here -->
                                    <!-- +1 button start here -->
                                    <td>
                                        
                                        <!-- Place this tag where you want the +1 button to render -->
                                <g:plusone size="medium" annotation="inline" href="http://teche.tk/Item.jsp?ItemID=<%=itemID %>"></g:plusone>
                                <!-- Place this render call where appropriate -->
                                <script type="text/javascript">
                                    (function() {    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
                                        po.src = 'https://apis.google.com/js/plusone.js';
                                        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
                                    })();
                                </script>
                                        <!-- <iframe src="http://dev.syskall.com/plusone/?url=patuck.net" marginheight="0" marginwidth="0" frameborder="0" scrolling="no" style="border:0;width:110px;height:30px;"></iframe> --!>
                                    </td>
                                    <!-- +1 button end here -->
                                </tr>
                            </table>
                            
                        </div>
                    </div>
                        
                    <%
                }
                
                %>
                
                <div id="PageSelecter">
                    <table align="center">
                        <tr>
                            <td>
                                <a href="Categories.jsp?Category=<%=request.getParameter("Category") %>&Page=<%=(pageNo!=0 ? (pageNo-1) : 0) %>">
                                Previous
                                </a>
                            </td>
                            <td>
                                Page <%=(pageNo+1) %>
                            </td>
                            <td>
                                <%
                                result= db.executeQuery("SELECT COUNT(`TimeStamp`) FROM `catalog`.`item` WHERE `item`.`CategoryID` = '" + request.getParameter("Category") +"' "+ whereClauze + " ;");
                                result.next();
                                %>
                                <a href="Categories.jsp?Category=<%=request.getParameter("Category") %>&Page=<%= Long.parseLong(result.getString(1))<=((pageNo+1)*5)  ? pageNo :(pageNo+1) %>">
                                Next
                                </a>
                                <%
                                db.disconnect();
                                %>
                            </td>
                        </tr>
                    </table>
                </div>
                
            </div>
                
                
                
              
         
            <!-- Left colum ends here -->
		
            <!-- Right colum starts here -->
            <div id="right">
                <%
                if(isModerator)
                {
                    if(isAdmin)
                    {
                        %>
                        <div id="controls">
                        <%
                    }
                    else
                    {
                        %>
                        <div id="controls" style="border-bottom: 1px solid #BBBBBB; padding-bottom:14px;">
                        <%
                    }
                    %>
                    <a href="AddItem.jsp">  
                        <img src="Images/Icons/add.png" width="15" height="15"/> Add Item
                    </a>
                    <br/>
                </div>
                <%
                }
                if(isAdmin)
                {
                    %>
                    <div id="controls" style="border-bottom: 1px solid #BBBBBB; padding-bottom:14px;">
                        <a href="AddCategory.jsp">
                            <img src="Images/Icons/add.png" width="15" height="15" />Add Category
                        </a>
                        <br />
                        <a href="EditCategory.jsp?CategoryID=<%=request.getParameter("Category") %>">
                            <img src="Images/Icons/pencil.png" width="15" height="15" />Edit Category
                        </a>
                        <br />
                        <a href="RemoveCategory.jsp?CategoryID=<%=request.getParameter("Category") %>">
                            <img src="Images/Icons/delete.png" width="15" height="15" />Remove Category
                        </a>
                        <br />
                    </div>
                    <%
                }
                %>
                <!-- Google Add Code -->
                <div align="center">
                    <br />
                    <script type="text/javascript">
                        <!--
                        google_ad_client = "ca-pub-4207702273321885";
                        /* TYBSC - Project - TechE - Right Panel - Wide Scyscraper */
                        google_ad_slot = "2310136425";
                        google_ad_width = 160;
                        google_ad_height = 600;
                        //-->
                    </script>
                    <script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
                    </script>
                </div>
                <!-- Google Add Code -->
                
            </div>
            <!-- Right colum ends here -->
	
            <!-- Footer starts here -->
            <div id="footer">
                <p>&copy; TechE</p>
            </div>
            <!-- Footer starts here -->

        </div>

    </body>
</html>
