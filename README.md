AgendaPro para Android
Projeto inicial Android usando Capacitor. Inclui interface responsiva e funcionalidades locais para clientes, serviços, agenda e receitas.
Gerar o APK
Requisitos: Node.js 20+, Android Studio e Android SDK instalado.
Extraia o ZIP.
No terminal, entre na pasta agendapro-android.
Execute:
npm install
npx cap add android
npx cap sync android
npx cap open android
No Android Studio, aguarde a sincronização do Gradle.
Para gerar APK: Build > Build Bundle(s) / APK(s) > Build APK(s).
O APK de debug será criado em android/app/build/outputs/apk/debug/app-debug.apk.
Observações importantes
Este ZIP é o projeto-fonte preparado para gerar o APK; não é um APK já compilado.
O login desta versão é apenas um perfil local de demonstração, não autenticação segura por servidor.
Os dados ficam no armazenamento local do aplicativo/navegador e podem ser perdidos ao limpar os dados ou desinstalar. Implemente backend, autenticação real, backup e política de privacidade antes de uso comercial com dados de clientes.
Não armazene dados sensíveis nem use esta versão como sistema de produção sem revisão de segurança.
