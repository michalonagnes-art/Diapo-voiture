// Gestion de la navigation entre les diapositives
let currentSlide = 0;
const slides = document.querySelectorAll('.slide');
const totalSlides = slides.length;

const prevBtn = document.getElementById('prevBtn');
const nextBtn = document.getElementById('nextBtn');

// Fonction pour afficher une diapositive
function showSlide(index) {
    // Masquer toutes les diapositives
    slides.forEach(slide => {
        slide.classList.remove('active');
    });
    
    // Afficher la diapositive actuelle
    if (slides[index]) {
        slides[index].classList.add('active');
    }
    
    // Mettre à jour les boutons de navigation
    updateNavigationButtons();
    
    // Réinitialiser les animations des voitures
    resetCarAnimations();
}

// Réinitialiser les animations des voitures pour la nouvelle diapositive
function resetCarAnimations() {
    const activeSlide = document.querySelector('.slide.active');
    if (activeSlide) {
        const carBoxes = activeSlide.querySelectorAll('.car-box');
        carBoxes.forEach((box, index) => {
            box.style.animation = 'none';
            setTimeout(() => {
                box.style.animation = '';
                box.style.animationDelay = `${index * 0.1}s`;
            }, 10);
        });
    }
}

// Fonction pour mettre à jour l'état des boutons
function updateNavigationButtons() {
    if (prevBtn && nextBtn) {
        prevBtn.disabled = currentSlide === 0;
        nextBtn.disabled = currentSlide === totalSlides - 1;
    }
}

// Fonction pour aller à la diapositive précédente
function prevSlide() {
    if (currentSlide > 0) {
        currentSlide--;
        showSlide(currentSlide);
    }
}

// Fonction pour aller à la diapositive suivante
function nextSlide() {
    if (currentSlide < totalSlides - 1) {
        currentSlide++;
        showSlide(currentSlide);
    }
}

// Event listeners pour les boutons
if (prevBtn) {
    prevBtn.addEventListener('click', prevSlide);
}

if (nextBtn) {
    nextBtn.addEventListener('click', nextSlide);
}

// Navigation au clavier
document.addEventListener('keydown', (e) => {
    if (e.key === 'ArrowLeft') {
        prevSlide();
    } else if (e.key === 'ArrowRight') {
        nextSlide();
    }
});

// Gestion des erreurs d'images
function handleImageError(img) {
    img.style.display = 'none';
    const placeholder = img.parentElement.querySelector('.car-placeholder');
    if (placeholder) {
        placeholder.style.display = 'flex';
    }
}

// Ajouter les gestionnaires d'erreur à toutes les images
document.addEventListener('DOMContentLoaded', () => {
    const images = document.querySelectorAll('.car-image img');
    images.forEach(img => {
        img.addEventListener('error', () => {
            handleImageError(img);
        });
        
        // Si l'image est déjà chargée et a échoué
        if (!img.complete || img.naturalHeight === 0) {
            img.addEventListener('error', () => {
                handleImageError(img);
            }, { once: true });
        }
    });
});

// Initialisation au chargement de la page
window.addEventListener('load', () => {
    showSlide(0);
    updateNavigationButtons();
});

// Animation de la flèche au changement de diapositive
function animateArrow() {
    const arrowLine = document.querySelector('.slide.active .arrow-line');
    const arrowHead = document.querySelector('.slide.active .arrow-head');
    
    if (arrowLine && arrowHead) {
        arrowLine.style.transition = 'width 0.8s ease';
        arrowHead.style.transition = 'left 0.8s ease';
    }
}

// Observer pour animer la flèche quand la diapositive change
const observer = new MutationObserver(() => {
    animateArrow();
});

// Observer les changements de classe active
slides.forEach(slide => {
    observer.observe(slide, {
        attributes: true,
        attributeFilter: ['class']
    });
});

// Animation initiale
animateArrow();
