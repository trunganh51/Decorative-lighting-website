<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${empty sessionScope.user or sessionScope.user.role ne 'admin'}">
    <c:redirect url="${pageContext.request.contextPath}/auth?action=login"/>
</c:if>
