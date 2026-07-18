import sys
import re

def refactor_dashboard():
    with open('web/dashboard.jsp', 'r', encoding='utf-8') as f:
        content = f.read()
    
    top = '''<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Staff, java.util.List"%>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    boolean isAdmin = "Admin".equals(staff.getRole());
    request.setAttribute("pageTitle", "Dashboard - Quản lý Thư viện");
    request.setAttribute("activePage", "dashboard");
%>
<jsp:include page="/includes/header.jsp" />
'''
    bottom = '\n<jsp:include page="/includes/footer.jsp" />\n'
    
    new_content = re.sub(r'(?s).*?(?=<!-- QUICK LINKS SECTION -->)', top, content, 1)
    new_content = re.sub(r'(?s)\s*</div>\s*</div>\s*</body>\s*</html>\s*$', bottom, new_content, 1)
    
    with open('web/dashboard.jsp', 'w', encoding='utf-8') as f:
        f.write(new_content)

def refactor_member():
    with open('web/member_list.jsp', 'r', encoding='utf-8') as f:
        content = f.read()

    top = '''<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Staff" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    boolean isAdmin = "Admin".equals(staff.getRole());
    request.setAttribute("pageTitle", "Quản lý Thành viên - Thư viện");
    request.setAttribute("activePage", "members");
%>
<jsp:include page="/includes/header.jsp" />
<style>
'''
    bottom = '\n<jsp:include page="/includes/footer.jsp" />\n'
    
    new_content = re.sub(r'(?s).*?(?=/\* TOOLBAR \*/)', top, content, 1)
    # We replace the closing </div></div> right before <!-- DELETE MODAL -->
    # and we also need to append footer include, BUT footer.jsp has </body></html>!
    # Let's remove </body>\s*</html>
    new_content = re.sub(r'(?s)</body>\s*</html>', '', new_content, 1)
    # And replace the </div></div> right after the content with the footer include
    # wait, the structure is:
    #             </div> <!-- table-card -->
    #         </div> <!-- content -->
    #     </div> <!-- main -->
    #     <!-- DELETE MODAL -->
    # Since footer.jsp closes content and main, we should remove the </div></div> that closes content and main,
    # and put <jsp:include page="/includes/footer.jsp" /> AFTER the modal and scripts.
    # Wait, if we put footer after modal/script, then the modal/script will be INSIDE content/main.
    # That is perfectly fine! In fact, it's better.
    new_content = re.sub(r'(?s)\s*</div>\s*</div>\s*(?=<!-- DELETE MODAL -->)', '\n', new_content, 1)
    new_content += bottom

    with open('web/member_list.jsp', 'w', encoding='utf-8') as f:
        f.write(new_content)

def refactor_loan():
    with open('web/quan_li_tra_va_muon/loan_list.jsp', 'r', encoding='utf-8') as f:
        content = f.read()

    top = '''<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.Transaction, model.Staff"%>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    boolean isAdmin = "Admin".equals(staff.getRole());
    request.setAttribute("pageTitle", "Danh sách mượn sách");
    request.setAttribute("activePage", "loans");
%>
<jsp:include page="/includes/header.jsp" />
<style>
'''
    bottom = '\n<jsp:include page="/includes/footer.jsp" />\n'
    
    new_content = re.sub(r'(?s).*?(?=/\* MESSAGES \*/)', top, content, 1)
    new_content = re.sub(r'(?s)\s*</div>\s*</div>\s*</body>\s*</html>\s*$', bottom, new_content, 1)

    with open('web/quan_li_tra_va_muon/loan_list.jsp', 'w', encoding='utf-8') as f:
        f.write(new_content)

if __name__ == '__main__':
    refactor_dashboard()
    refactor_member()
    refactor_loan()
