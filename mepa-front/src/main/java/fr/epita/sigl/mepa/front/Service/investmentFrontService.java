package fr.epita.sigl.mepa.front.Service;

import fr.epita.sigl.mepa.core.domain.AppUser;
import fr.epita.sigl.mepa.core.domain.Investment;
import fr.epita.sigl.mepa.front.model.investment.Investor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;

/**
 * Created by Simon on 26/07/2016.
 */
@Service
public class investmentFrontService {

    public investmentFrontService() {

    }

    /**
     * This function takes in parameter a list of investor and fill it with a new investor, created thanks to the user
     * and invest information
     * @param listOfInvestors
     * @param invest
     * @param user
     * @param listmailinvestor
     * @param counteOneInvestmentPerUser : if this parameter is set, the list will concatenate only one time a investor
     * @return
     */
    public float mergeInvestor(ArrayList<Investor> listOfInvestors, Investment invest, AppUser user, ArrayList<String> listmailinvestor, boolean counteOneInvestmentPerUser) {
        boolean investorIsPresent = false;
        String firstname;
        String lastname;
        String email;
        Date created = invest.getCreated();
        Float amount = invest.getAmount();

        boolean anonymous = invest.isAnonymous();
        if (!anonymous || counteOneInvestmentPerUser) {
            firstname = user.getFirstName();
            lastname = user.getLastName();
            if (counteOneInvestmentPerUser && listmailinvestor.indexOf(user.getLogin()) == -1) {
                listmailinvestor.add(user.getLogin());
                investorIsPresent = true;
            }
        } else {
            firstname = "Anonyme";
            lastname = "Anonyme";
            listmailinvestor.add("anonyme");
        }
        email = user.getLogin();
        Investor tmpInvestor = new Investor(email, firstname, lastname, amount, created, anonymous);
        if (investorIsPresent) {
            groupInvestors(listOfInvestors, tmpInvestor);
        } else {
            listOfInvestors.add(tmpInvestor);
        }
        return amount;
    }

    public void groupInvestors(ArrayList<Investor> listOfInvestors, Investor investor) {

        if (investor.isAnonymous()) {
            listOfInvestors.add(investor);
            return;
        }

        for (Investor i : listOfInvestors) {
            if (i.getEmail().equals(investor.getEmail())) {
                i.setMoneyAmount(i.getMoneyAmount() + investor.getMoneyAmount());
                return;
            }
        }
        listOfInvestors.add(investor);
    }
}