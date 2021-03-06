<%--
  Created by IntelliJ IDEA.
  User: Simon MACE
  Date: 23/07/2016
  Time: 20:57
  To change this template use File | Settings | File Templates.
--%>
<%@ include file="/WEB-INF/views/includes/common.jsp" %>
<div class="container">
    <div class="page-header col-md-12"><h1 align="center">Paiement de ${rewardName}</h1></div>
    <div class="col-md-12 investFormInside">
        <div class="row">
            <div class="col-md-2"></div>
            <div class="col-md-8">
                <div class="panel panel-primary projectDescriptionInvest">
                    <!-- Default panel contents -->
                    <div class="panel-heading">Description</div>
                    <div class="panel-body">
                        <p>
                            ${description}
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-2"></div>
        </div>
        <div class="col-md-12 investForm">
            <c:url var="payReward" value="/invest/${projectId}/rewardpay/${rewardId}/invest"/>
            <form:form role="form" action="${payReward}" method="post" modelAttribute="User">
                <label class="investFormInside col-md-12">Montant :</label>
                <div class="col-md-12 InvestFormInside">
                    <div class="input-group">
                        <span class="input-group-addon">${amountCurrency}</span>
                        <input name="investAmount" id="input-with-keypress"
                           class="form-control" type="number" required="required" value="${rewardPrice}"/>
                </div>
                <br/>
                    <div class="col-md-4">
                        <div class="col-md-1 checkbox">
                            <label><input type="checkbox" name="anonymous_id" value=""/>Anonyme</label>
                                <%--      <label class="investFormInside col-md-12">Anonyme:</label>--%>
                        </div>
                    </div>
                <br/>
                <div class="col-md-4">
                    <p align="center"><input type="submit" class="btn btn-primary InvestFormInside" value="Contribuer"></p>
                </div>
                <div class="col-md-4"></div>
            </form:form>
        </div>
    </div>
</div>

