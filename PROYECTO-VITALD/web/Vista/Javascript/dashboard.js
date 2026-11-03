document.addEventListener('DOMContentLoaded', () => {

    const fechaElemento = document.getElementById('fecha-actual');

    if (fechaElemento) {
        const opciones = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        const hoy = new Date();
        fechaElemento.textContent = hoy.toLocaleDateString('es-ES', opciones);
    }

  
    const logoutBtn = document.querySelector('.logout');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', (e) => {
            if(!confirm('¿Estás seguro de que deseas salir del sistema VitalDentist?')) {
                e.preventDefault();
            }
        });
    }

    document.querySelectorAll('.js-card-link[data-href]').forEach((card) => {
        card.addEventListener('click', () => {
            window.location.href = card.dataset.href;
        });

        card.addEventListener('keydown', (event) => {
            if (event.key === 'Enter' || event.key === ' ') {
                event.preventDefault();
                card.click();
            }
        });
    });
});
