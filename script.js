document.addEventListener('DOMContentLoaded', () => {
  const progressBar = document.querySelector('.reading-progress-bar');
  if (progressBar) {
    window.addEventListener('scroll', () => {
      const winScroll = document.documentElement.scrollTop || document.body.scrollTop;
      const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
      const scrolled = height > 0 ? (winScroll / height) * 100 : 0;
      progressBar.style.width = scrolled + '%';
    });
  }

  const themeBtn = document.querySelector('.btn-theme-optics');
  const savedTheme = localStorage.getItem('pupilacademy_theme');
  if (savedTheme === 'light') {
    document.body.classList.add('theme-optics-light');
    if (themeBtn) themeBtn.textContent = 'Observatory Dark';
  }
  if (themeBtn) {
    themeBtn.addEventListener('click', () => {
      const isLight = document.body.classList.toggle('theme-optics-light');
      themeBtn.textContent = isLight ? 'Observatory Dark' : 'Observatory Light';
      localStorage.setItem('pupilacademy_theme', isLight ? 'light' : 'dark');
    });
  }

  const mobileToggle = document.querySelector('.mobile-toggle-pupil');
  const navMenu = document.querySelector('.pupil-nav-menu');
  if (mobileToggle && navMenu) {
    mobileToggle.addEventListener('click', () => {
      const isOpen = navMenu.style.display === 'flex';
      navMenu.style.display = isOpen ? 'none' : 'flex';
      if (!isOpen) {
        navMenu.style.flexDirection = 'column';
        navMenu.style.position = 'absolute';
        navMenu.style.top = '100%';
        navMenu.style.left = '0';
        navMenu.style.right = '0';
        navMenu.style.background = 'var(--bg-pupil-surface)';
        navMenu.style.padding = '1.75rem';
        navMenu.style.boxShadow = 'var(--shadow-pupil)';
        navMenu.style.borderBottom = '1px solid var(--border-pupil)';
      }
    });
  }

  const lightSelect = document.getElementById('ambient-light-select');
  const modalitySelect = document.getElementById('optical-modality-select');
  const radiusSelect = document.getElementById('corneal-radius-select');
  const pupilDisplay = document.getElementById('calc-pupil-diameter');
  const illuminanceDisplay = document.getElementById('calc-retinal-lux');
  const rmsDisplay = document.getElementById('calc-wavefront-rms');

  function calculateOpticalMetrics() {
    if (!lightSelect || !modalitySelect || !radiusSelect) return;
    const light = lightSelect.value;
    const modality = modalitySelect.value;

    let diameter = '2.4 mm (Miosis Active)';
    let illuminance = '4,520 Trolands (Photopic Saturation)';
    let rms = '0.08 Âµm RMS (Diffraction Limited)';

    if (light === 'mesopic') {
      diameter = '4.2 mm (Intermediate Aperture)';
      illuminance = '680 Trolands (Balanced Rod/Cone)';
      rms = '0.14 Âµm RMS (Optimal Modulation)';
    } else if (light === 'scotopic') {
      diameter = '6.8 mm (Mydriasis Dilation)';
      illuminance = '18 Trolands (Rod Sensitivity Peak)';
      rms = '0.28 Âµm RMS (Spherical Aberration Prominent)';
    }

    if (modality === 'aberrometry') {
      rms += ' [Zernike 4th Order]';
    } else if (modality === 'infrared') {
      rms += ' [PLR Constriction Velocity 5.2 mm/s]';
    }

    if (pupilDisplay) pupilDisplay.innerHTML = diameter;
    if (illuminanceDisplay) illuminanceDisplay.innerHTML = illuminance;
    if (rmsDisplay) rmsDisplay.innerHTML = rms;
  }

  if (lightSelect && modalitySelect && radiusSelect) {
    lightSelect.addEventListener('change', calculateOpticalMetrics);
    modalitySelect.addEventListener('change', calculateOpticalMetrics);
    radiusSelect.addEventListener('change', calculateOpticalMetrics);
    calculateOpticalMetrics();
  }

  const faqBtns = document.querySelectorAll('.faq-pupil-btn');
  if (faqBtns.length > 0) {
    faqBtns.forEach(btn => {
      btn.addEventListener('click', () => {
        const item = btn.parentElement;
        const isActive = item.classList.contains('active');
        document.querySelectorAll('.faq-pupil-item').forEach(i => i.classList.remove('active'));
        if (!isActive) item.classList.add('active');
      });
    });
  }

  const searchInput = document.getElementById('pupil-search-input');
  const blogCards = document.querySelectorAll('.blog-pupil-card');
  if (searchInput && blogCards.length > 0) {
    searchInput.addEventListener('input', () => {
      const q = searchInput.value.toLowerCase().trim();
      blogCards.forEach(card => {
        const text = card.textContent.toLowerCase();
        card.style.display = (q === '' || text.includes(q)) ? 'flex' : 'none';
      });
    });
  }
});