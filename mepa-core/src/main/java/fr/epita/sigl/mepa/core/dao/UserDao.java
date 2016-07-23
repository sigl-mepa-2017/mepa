package fr.epita.sigl.mepa.core.dao;

import fr.epita.sigl.mepa.core.domain.User;

import java.util.ArrayList;
import java.util.List;

public interface UserDao {

    void create(User user);

    User getById(Long id);

    List<User> getByFirstName(String firstName);

    List<User> getByLastName(String lastName);

    User getByLogin(String login);

    List<User> getAll();

}
