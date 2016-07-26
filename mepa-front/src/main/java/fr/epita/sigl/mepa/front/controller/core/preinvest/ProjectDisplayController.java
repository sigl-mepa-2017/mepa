package fr.epita.sigl.mepa.front.controller.core.preinvest;

import fr.epita.sigl.mepa.core.domain.AppUser;
import fr.epita.sigl.mepa.core.domain.CommentsModel;
import fr.epita.sigl.mepa.core.domain.Investment;
import fr.epita.sigl.mepa.core.domain.Project;
import fr.epita.sigl.mepa.core.service.CommentsModelService;
import fr.epita.sigl.mepa.core.service.InvestmentService;
import fr.epita.sigl.mepa.core.service.ProjectService;
import fr.epita.sigl.mepa.front.controller.investment.InvestController;
import org.hibernate.Hibernate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

@Controller
@RequestMapping("/core/preinvest") // The adress of the component
@SessionAttributes({})
public class ProjectDisplayController {

    private static final Logger LOG = LoggerFactory.getLogger(ProjectDisplayController.class);

    protected static final String PROJECT_ATTRIBUTE = "project";
    protected static final String PROJECTS_LIST_ATTRIBUTE = "project_list";

    /*PostInvest Total Amount invested on Project*/
    protected static final String PROJECT_TOTAL_AMOUNT = "totalProjectAmountInvested";

    @Autowired
    private ProjectService projectService;

    @Autowired
    private InvestmentService investmentService;

    @Autowired
    private CommentsModelService commentsModelService;

    @Autowired
    private InvestController investController;


    @RequestMapping(value = {"/projectDisplay/{projectId}"}) // The adress to call the function
    public String projectDisplay(HttpServletRequest request, ModelMap modelMap, @PathVariable long projectId) {
        /* Code your logic here */
        Project project = this.projectService.getProjectById(projectId);
        modelMap.addAttribute(PROJECT_ATTRIBUTE, project);

        /*PostInvest Total Amount invested on Project*/
        Float totalProjectAmountInvested = getProjectMoneyInvested(projectId);
        modelMap.addAttribute(PROJECT_TOTAL_AMOUNT, totalProjectAmountInvested);
        /*\PostInvest Total Amount invested on Project*/

         /*Get the current user in the session in order to know if he is
        * connected */
        AppUser userco = new AppUser();
        userco = (AppUser) request.getSession().getAttribute("userCo");
        modelMap.addAttribute("userco", userco);

        /* Check if the user connected is the administrator of the projet */
        if (userco != null && project != null && ((userco.getId().equals(project.getUser_id()))
                || (userco.getFirstName().compareTo("Admin") == 0)))
            request.getSession().setAttribute("isAdmin", "true");
        else
            request.getSession().setAttribute("isAdmin", "false");

        investController.investorsList(modelMap, request, project);
        return "/preinvest/projectDisplay";
    }

    @RequestMapping(value = {"/projectDisplay/{projectId}/comment"}) // The adress to call the function
    public String projectDisplayComment(HttpServletRequest request, ModelMap modelMap, @PathVariable long projectId) {
        /* Code your logic here */
        Project project = this.projectService.getProjectById(projectId);
        modelMap.addAttribute(PROJECT_ATTRIBUTE, project);

        /*PostInvest Total Amount invested on Project*/
        Float totalProjectAmountInvested = getProjectMoneyInvested(projectId);
        modelMap.addAttribute(PROJECT_TOTAL_AMOUNT, totalProjectAmountInvested);
        /*\PostInvest Total Amount invested on Project*/

         /*Get the current user in the session in order to know if he is
        * connected */
        AppUser userco = new AppUser();
        userco = (AppUser) request.getSession().getAttribute("userCo");
        modelMap.addAttribute("userco", userco);

        /* Check if the user connected is the administrator of the projet */
        if (userco != null && userco.getId() == project.getUser_id())
            request.getSession().setAttribute("isAdmin", "true");

        else
            request.getSession().setAttribute("isAdmin", "false");

        investController.investorsList(modelMap, request, project);

        List<CommentsModel> list = this.commentsModelService.getAllCommentsModels();
        /*Sort of the comments by the arriving tickets*/
        List<CommentsModel>new_c_models = new ArrayList<CommentsModel>();
        ListIterator<CommentsModel> i= list.listIterator(list.size());
        while(i.hasPrevious())
        {
            new_c_models.add(i.previous());
        }
        modelMap.addAttribute("new_c_models",new_c_models);
        return "/preinvest/projectDisplay/Comment";

    }


    @RequestMapping(value = {"/", "/projectList"}) // The adress to call the function
    public String projectList(ModelMap modelMap) {
        List<Project> projects = this.projectService.getAllUnfinishedProjects();
        int i = 0;
        for (Project p: projects)
            Hibernate.initialize(p.getRewards());
        modelMap.addAttribute(PROJECTS_LIST_ATTRIBUTE, projects);
        return "/preinvest/projectList"; // The adress of the JSP coded in tiles.xml
    }

    @RequestMapping(value = {"/projectListInclude"}) // The adress to call the function
    public String projectListInclude(HttpServletRequest request, ModelMap modelMap) {
        /* Code your logic here */

        this.projectList(modelMap);
        return "/preinvest/projectListInclude"; // The adress of the JSP coded in tiles.xml
    }

    /*PostInvest Total Amount invested on Project*/
    public Float getProjectMoneyInvested(long projectId) {
        ArrayList<Investment> investments = new ArrayList<Investment>(investmentService.getAllInvestments());
        Float totalProjectAmount = 0.0f;
        for (Investment inv : investments)
            if (inv.getProjectId() == projectId)
                totalProjectAmount += inv.getAmount();
        return totalProjectAmount;
    }
    /*\PostInvest Total Amount invested on Project*/
}
