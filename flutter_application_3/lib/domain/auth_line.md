Login → Autenticación → ¿Usuario existe? 
    → Sí → Redirigir según typeUser
    → No → Crear usuario (typeUser=NotSpecified) → ChoosingRoleScreen
        ↓
        Customer → Actualizar a customer → MainApp
        ↓
        Owner → OwnerSurveyScreen → Actualizar a isWaiting → WaitingApprovalScreen
            ↓
            (Admin aprueba) → Actualizar a owner → OwnerDashboard