/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.catalog.web;

import com.catalog.model.MySQL;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Reshad
 */
@WebServlet(name = "CheckItem", urlPatterns =
{
    "/Validation/CheckItem"
})
public class CheckItem extends HttpServlet
{

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try
        {
            response.setContentType("text/html;charset=UTF-8");
            String name = request.getParameter("Name");
            MySQL db=new MySQL();
            db.connect();
            ResultSet rs= db.executeQuery("SELECT `ItemName` FROM item WHERE `CategoryID`='" + request.getParameter("Category") + "';");
            String isPresent="0";
            try
            {
                while(rs.next())
                {
                    if(name.equals(rs.getString(1)))
                    {
                        isPresent="1";
                    }
                }
            }
            catch (SQLException ex)
            {
                Logger.getLogger(CheckUserName.class.getName()).log(Level.SEVERE, null, ex);
            }
            out.println(isPresent);
            db.disconnect();
            
            /* TODO output your page here
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CheckItem</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CheckItem at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
             */
        }
        finally
        {            
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        processRequest(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo()
    {
        return "Short description";
    }// </editor-fold>
}
