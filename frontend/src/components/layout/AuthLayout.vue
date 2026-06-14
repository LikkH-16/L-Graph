<template>
  <div class="auth-layout">
    <div class="auth-layout__bg">
      <div class="auth-layout__orb auth-layout__orb--1"></div>
      <div class="auth-layout__orb auth-layout__orb--2"></div>
      <div class="auth-layout__orb auth-layout__orb--3"></div>
    </div>
    <div class="auth-layout__card">
      <div class="auth-layout__logo">
        <svg width="40" height="40" viewBox="0 0 40 40" fill="none">
          <circle cx="20" cy="12" r="6" stroke="#7c5ce7" stroke-width="2.5" fill="none"/>
          <circle cx="12" cy="28" r="6" stroke="#7c5ce7" stroke-width="2.5" fill="none"/>
          <circle cx="28" cy="28" r="6" stroke="#7c5ce7" stroke-width="2.5" fill="none"/>
          <line x1="17" y1="17" x2="14" y2="23" stroke="#7c5ce7" stroke-width="1.5" opacity="0.6"/>
          <line x1="23" y1="17" x2="26" y2="23" stroke="#7c5ce7" stroke-width="1.5" opacity="0.6"/>
          <line x1="17" y1="30" x2="23" y2="30" stroke="#7c5ce7" stroke-width="1.5" opacity="0.6"/>
        </svg>
        <span class="auth-layout__brand">L-Graph</span>
      </div>
      <slot>
        <transition name="fade" mode="out-in">
          <router-view />
        </transition>
      </slot>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.auth-layout {
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--color-bg-primary);
  overflow: hidden;
  position: relative;

  &__bg {
    position: fixed;
    inset: 0;
    overflow: hidden;
    pointer-events: none;
  }

  &__orb {
    position: absolute;
    border-radius: 50%;
    filter: blur(80px);
    opacity: 0.12;

    &--1 {
      width: 500px;
      height: 500px;
      background: #7c5ce7;
      top: -20%;
      right: -10%;
      animation: orb-float 20s ease-in-out infinite;
    }

    &--2 {
      width: 400px;
      height: 400px;
      background: #3498db;
      bottom: -15%;
      left: -5%;
      animation: orb-float 25s ease-in-out infinite reverse;
    }

    &--3 {
      width: 300px;
      height: 300px;
      background: #2ecc71;
      top: 40%;
      left: 30%;
      animation: orb-float 18s ease-in-out infinite 5s;
    }
  }

  &__card {
    position: relative;
    z-index: 1;
    width: 420px;
    max-width: calc(100vw - 32px);
    padding: var(--space-10);
    background: var(--color-bg-card);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-xl);
    box-shadow: var(--shadow-lg);
  }

  &__logo {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: var(--space-3);
    margin-bottom: var(--space-8);
  }

  &__brand {
    font-size: var(--font-size-2xl);
    font-weight: 700;
    color: var(--color-text-primary);
    letter-spacing: -0.02em;
  }
}

@keyframes orb-float {
  0%, 100% { transform: translate(0, 0) scale(1); }
  33% { transform: translate(30px, -30px) scale(1.1); }
  66% { transform: translate(-20px, 20px) scale(0.9); }
}
</style>
