package com.lgraph.security;

import com.lgraph.entity.User;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

/**
 * Utility methods for extracting current-user information from the SecurityContext.
 */
public final class SecurityUtils {

    private SecurityUtils() {
    }

    /**
     * Extract the authenticated user's ID from the SecurityContext.
     * Returns null if unauthenticated.
     */
    public static Long getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return null;
        }
        Object principal = auth.getPrincipal();
        if (principal instanceof Long id) {
            return id;
        }
        return null;
    }

    /**
     * Extract the full User entity stored as details in the Authentication token.
     * Returns null if unauthenticated or details are not a User instance.
     */
    public static User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return null;
        }
        Object details = auth.getDetails();
        if (details instanceof User user) {
            return user;
        }
        return null;
    }
}
