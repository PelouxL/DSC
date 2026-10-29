package com.example.dds.secu;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.servlet.util.matcher.PathPatternRequestMatcher;

@Configuration
@EnableWebSecurity
public class WebSecu {

    @Bean
    public PasswordEncoder encoder(AdherentService adherentService) {
        return adherentService.encoder;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        var mvc = PathPatternRequestMatcher.withDefaults();

        http
            .authorizeHttpRequests(auth -> auth
                // Pages publiques
                .requestMatchers(
                    mvc.matcher("/"), 
                    mvc.matcher("/formInscription"), 
                    mvc.matcher("/formConnexion"), 
                    mvc.matcher("/css/**")
                ).permitAll()
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/formConnexion") 
                .usernameParameter("email")   
                .passwordParameter("mdp")    
                .defaultSuccessUrl("/", true)
                .permitAll()
            )
            .logout(logout -> logout
                .logoutSuccessUrl("/")
                .permitAll()
            );

        return http.build();
    }
}