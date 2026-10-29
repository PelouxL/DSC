package com.example.dds.secu;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.dds.controller.Adherent;
import com.example.dds.controller.AdherentRepository;

import java.util.List;
import java.util.Optional;

@Service
public class AdherentService implements UserDetailsService {

    @Autowired
    AdherentRepository adherentRepo;

    public final PasswordEncoder encoder = new BCryptPasswordEncoder();

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        Optional<Adherent> opt = adherentRepo.findByEmail(email);
        if (opt.isEmpty()) {
            throw new UsernameNotFoundException("Adhérent non trouvé : " + email);
        }
        Adherent a = opt.get();

        List<GrantedAuthority> authorities = AuthorityUtils.createAuthorityList("ROLE_USER");
        
        return new org.springframework.security.core.userdetails.User(
            a.getEmail(),
            a.getMdp(),
            authorities
    );
    }

    public void setComputingDerivedPassword(Adherent a, String rawPassword) {
        String codedPassword = encoder.encode(rawPassword);
        a.setMdp(codedPassword);
    }
}
