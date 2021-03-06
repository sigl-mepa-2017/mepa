<%--
  Created by IntelliJ IDEA.
  User: Guillaume
  Date: 25/07/2016
  Time: 17:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/includes/common.jsp" %>

<script>
    $("#slideshow > div:gt(0)").hide();

    setInterval(function () {
        $('#slideshow > div:first')
                .fadeOut(1000)
                .next()
                .fadeIn(1000)
                .end()
                .appendTo('#slideshow');
    }, 3000);
</script>



<div class="container">
    <header class="title projectHeader">
        <h1 class="short">${project.name}</h1>
    </header>

    <jsp:useBean id="now" class="java.util.Date"/>
    <c:if test="${totalDonation gt project.goalAmount  && project.endDate lt now}">
    <div class="container">
        <br>
        <div class="alert alert-success" >
            <h2><strong><center>Ce projet est terminé et a été financé !</center></strong></h2>
        </div>
    </div>
    </c:if>
    <c:if test="${totalDonation lt project.goalAmount  && project.endDate lt now}">
    <div class="container">
        <div class="alert alert-danger">
            <h2><strong><center>Ce Projet est terminé et n'a malheureusement pas été financé !</center></strong></h2>
        </div>
    </div>
    </c:if>

    <c:if test="${amount != null}">
        <div class="col-md-12 text-center alert alert-success investFormInside">
            Merci pour votre don de ${amount}€! Un mail de notification vous a été envoyé.
        </div>
    </c:if>
    <c:if test="${errorInvest != null and !empty errorInvest}">
        <div class="col-md-12 text-center alert alert-danger investFormInside">
                ${errorInvest}
        </div>
    </c:if>
    <div class="col-md-8 investFormInside">
        <div class="row">
            <div class="col-md-12">
                <nav class="navbar-collapse collapse">
                    <ul class="nav navbar-nav">
                        <li class="active">
                            <a href="/postinvest/project-end/${project.id}">Accueil de la page du projet
                                : ${project.name}</a>
                        </li>
                        <li>
                            <a href="/invest/comment">Commentaires</a>
                        </li>
                    </ul>
                </nav>
                <c:if test="${isComment != null && isComment == true}">

                </c:if>
                <%-- Part of the page where the slideshow and the project date are printed --%>
                <div class="row">
                    <div class="col-md-4" id="slideshow">
                        <c:forEach items="${project.imagesLinks}" var="image" varStatus="loop">
                            <div>
                                <img src="${image}" style="width:100%"
                                     class="projectImageInvest img-responsive img-rounded"/>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="col-md-8">
                        <div class="date-display firstDate">Date de début:</div>
                        <div class="date-display">${project.dateFormat("dd/MM/yyyy", project.startDate)}</div>
                        <div class="date-display">Date de fin:</div>
                        <div class="date-display">${project.dateFormat("dd/MM/yyyy", project.endDate)}</div>


                    </div>
                </div>

                <%-- Part of the page for Social buttons --%>
                <div class="col-md-12">
                    <%-- Facebook share button --%>
                    <div class="fb-share-button"
                         data-href="https://mepa.herokuapp.com/postinvest/project-end/${project.id}"
                         data-layout="button_count"
                         data-size="large"
                    <%-- Open the iframe --%>
                         data-mobile-iframe="true">
                        <a class="fb-xfbml-parse-ignore" target="_blank"
                           href="https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fmepa.herokuapp.com%2Fcore%2Fpreinvest%2F${project.id}&amp;src=sdkpreparse">
                            Partager
                        </a>
                    </div>
                    <br/>
                </div>

                <%-- Part of the page for the project description --%>
                <div class="panel panel-primary projectDescriptionInvest col-md-12">
                    <!-- Default panel contents -->
                    <div class="panel-heading">Description</div>
                    <div class="panel-body">
                        <p>${project.description}</p>
                    </div>
                </div>
            </div>
            <br/>

            <%-- Part of the page where the list of the investors are printed --%>
            <div class="col-md-12 investFormInside">
                <tr/>
                <div class="col-md-12 investFormInside">
                    <div class="col-md-12"><h2>Liste des contributeurs</h2></div>
                </div>
                <table class="col-md-12 table table-striped">
                    <thead>
                    <tr>
                        <th>Prénom ou email</th>
                        <th>Contribution</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:if test="${investorsList.size() > 0}">
                        <c:forEach items="${investorsList}" var="investor" varStatus="status">
                            <tr>
                                <c:choose>
                                    <c:when test="${investor.anonymous}">
                                        <td>Anonyme</td>
                                    </c:when>
                                    <c:when test="${investor.firstname == null or empty investor.firstname}">
                                        <td>${investor.email}</td>
                                    </c:when>
                                    <c:otherwise>
                                        <td>${investor.firstname}</td>
                                    </c:otherwise>
                                </c:choose>
                                <td>${investor.moneyAmount} €</td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    </tbody>
                </table>
            </div>
            <br/>
            <c:if test="${isAdmin != null && isAdmin == true && amountSize != null && amountSize == true}">
                <div class="col-md-12 download investFormInside">
                    <p align="center">
                        <a href="/invest/download/${project.id}"><span class="btn btn-primary">Téléchargement</span></a>
                    </p>
                </div>
            </c:if>
            <c:if test="${isAdmin != null && isAdmin == true && amountSize != null && amountSize == false}">
                <div class="col-md-12 download investFormInside disabled">
                    <p align="center">
                        <a href="/invest/download/${project.id}"><span class="btn btn-primary">Téléchargement</span></a>
                    </p>
                </div>
            </c:if>
        </div>
    </div>

    <%-- Right side bar for investing for the project and the list of counterparts --%>
    <aside class="col-md-4">
        <div class="row">
            <%-- Part of the page where the box of the invest button part --%>
            <div class="col-md-12 investForm">
                <div class="col-md-12 InvestFormInside">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="progress">
                                <%--<div class="progress-bar progress-bar-success" role="progressbar"
                                aria-valuenow="${projectPercentage}" aria-valuemin="0" aria-valuemax="100"
                                style="width:${projectPercentage}%">
                                    ${projectPercentage}%
                                </div>--%>
                                    <div class="progress-bar progress-bar-success" role="progressbar"
                                         aria-valuenow="${varpercentage}" aria-valuemin="0" aria-valuemax="100"
                                         style="width:${varpercentage}%">
                                        ${varpercentage}%
                                    </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <h4>Contribution totale : ${totalDonation}€</h4>
                    </div>
                    <div class="col-md-12">
                        <h4>Objectif : <%--${project.requestAmount}--%>${project.goalAmount} €</h4>
                    </div>
                    <div class="col-md-12">
                        <%-- POST INVEST --%>
                        <%-- PARTI POUR LE POST INVEST --%>
                        <jsp:useBean id="todayDate" class="java.util.Date"/>
                            <c:if test="${totalDonation lt project.goalAmount  && project.endDate lt now}">
                            <c:url var="addAmountUrl" value="/admin/addAmount/"/>
                            <form:form id="Post-Invest-Form" role="form" controller="AdminController" method="post"
                                       action="${addAmountUrl}">
                                <!--
                                <input id="amount" type="text" maxlength="20" placeholder="20" name="amount"/>
                                -->
                                <label for="amount">Vous souhaitez quand même montrer votre interet envers ce projet ? Indiquez la quantité d'argent que vous voudriez donner !</label>
                                <input id="amount" type="text" placeholder="20" name="amount"/>
                                <button id="test-feature-button" type="submit" class="btn btn-default">Soumettre</button>
                            </form:form>
                                <div id="hidden-msg-div" style="display:none">
                                    <p>
                                        Cette fonctionnalité est en cours de développement.
                                    </p>
                                </div>
                            </c:if>
                    </div>
                    <%-- <div class="container">
                        <c:url var="addAmountUrl" value="/admin/addAmount"/>
                        <form:form role="form" controller="AdminController" method="post"
                                   action="${addAmountUrl}">
                            <!--
                            <input id="amount" type="text" maxlength="20" placeholder="20" name="amount"/>
                            -->
                            <label for="amount">Quantité d'argent que vous voudriez donner</label>
                            <input id="amount" type="text" placeholder="20" name="amount"/>
                            <button type="submit" class="btn btn-default">Soumettre</button>
                        </form:form> </div> --%>

                </div>
            </div>
        </div>
    </aside>
</div>
<%--
                        <h4>Temps restant : ${projectLeftTime} jour(s)</h4>
                    </div>
                </div>
                <c:url var="investMoney" value="/invest/investMoney"/>
                <form:form role="form" action="${investMoney}" method="post" modelAttribute="User">
                    <div id="keypress"
                         class="InvestFormInside noUi-target noUi-ltr noUi-horizontal noUi-background col-md-12"></div>
                    <label class="investFormInside col-md-12">Montant (€):</label>
                    <div class="col-md-12 InvestFormInside">
                        <input name="investAmount" id="input-with-keypress"
                               class="form-control" type="text" required="required" readonly/>
                    </div>
                    <br/>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="investFormInside col-md-12">Anonyme:</label>
                        </div>
                        <div class="col-md-4"></div>
                        <div class="col-md-1 checkbox">
                            <label><input type="checkbox" name="anonymous_id" value=""/></label>
                        </div>
                        <div class="col-md-7"></div>
                    </div>

                    <div class="row">
                        <div class="col-md-4"></div>
                        <div class="col-md-4">
                            <p align="center"><input type="submit" class="btn btn-primary InvestFormInside"
                                                     value="Contribuer">
                            </p>
                        </div>
                        <div class="col-md-4"></div>
                    </div>
                </form:form>
            </div>
        </div>
        <%-- Part of the page where the slideshow and the project date are printed --%
        <div class="row">
            <div class="col-md-12 rewardSection">
                <h4 class="rewardHeader">Choisissez votre contrepartie</h4>
                <ol>
                    <li class="rewardItem" id="">
                        <h4 class="rewardTitle">Poster à partir 5€</h4>
                        <div class="rewardDescription">
                            <p>totomgoemogme</p>
                        </div>
                    </li>
                    <li class="rewardItem" id="">
                        <h4 class="rewardTitle">T-shirt à partir 10€</h4>
                        <div class="rewardDescription">
                            <p>totomgoemogme</p>
                        </div>
                    </li>
                    <c:if test="${rewardList != null and rewardList.size() > 0}">
                        <c:forEach items="${rewardList}" var="reward" varStatus="status">
                            <li class="rewardItem" name="reward/${reward.id}">
                                <h4 class="rewardTitle">${reward.name} à partir de ${reward.costStart}€</h4>
                                <div class="rewardDescription">
                                    <p>${reward.description}</p>
                                </div>
                            </li>
                        </c:forEach>
                    </c:if>
                </ol>

            </div>
        </div>
    </aside>
</div>
--%>

<c:url var="investSliderJs" value="/js/investment/nouislider.min.js"/>
<script src="${investSliderJs}"></script>
<c:url var="investSliderPersoJs" value="/js/investment/slider.js"/>
<script src="${investSliderPersoJs}"></script>
<script>
    $('#Post-Invest-Form').submit(function(e){
        e.preventDefault();
        var form = $('#Post-Invest-Form');
        $.ajax({
            url: "/admin/addAmount/",
            type: 'POST',
            data: form.serialize()
           });
        $('#hidden-msg-div').show();
        return false;
    });
</script>
