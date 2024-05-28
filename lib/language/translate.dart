import 'package:get/get.dart';

import '../utils/translation.dart';


class LanguageTranslate extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    Utils.getLanguageCode('English'): {
      'hello': 'Hello World',
      'language': 'Language',
      'select_language': 'Select Language',
      'select_image': 'Select Image',
      'translate': 'Translate',
      'translate_text': 'Translate Text',
      'translate_image': 'Translate Image',
      'translate_text_image': 'Translate Text/Image',
      'translate_text_image_desc': 'Translate text from image',
      'translate_text_desc': 'Translate text',
      'translate_image_desc': 'Translate image',
      'Type a message': 'Type a message',
      'Select Image': 'Select Image',
      'Camera': 'Camera',
      'Gallery': 'Gallery',
      'Home': 'Home',
      'Search': 'Search',
      'Profile': 'Profile',
      'QR Code': 'QR Code',
      'Choose Language': 'Choose Language',
      'Sindhi': 'Sindhi',
      'Hindi': 'Hindi',
      'Services': 'Services',
      'Spanish': 'Spanish',
      'French': 'French',
      "English": "English",
      'Arabic': 'Arabic',
      'Trustee': 'Trustee',
      'Categories': 'Categories',
      'View All': 'View All',
      'Electronics': 'Electronics',
      'Real Estate': 'Real Estate',
      'Jobs': 'Jobs',
      "Vehicles": "Vehicles",
      'Logout': 'Logout',
      "Settings": "Settings",
      "Mobiles": "Mobiles",
      "Home Appliances": "Home Appliances",
      "Bikes": "Bikes",
      "Catagories": "Catagories",
      "Property": "Property",
      "Other": "Other",
      "Furniture": "Furniture",
      "Fashion & Beauty": "Fashion & Beauty",
      "Books & Sports": "Books & Sports",
      "Kids": "Kids",
      "Business": "Business",
      "Login to your account": "Login to your account",
      "Please enter valid email": "Please enter valid email",
      "Please enter email": "Please enter email",
      "Email": "Email",
      "Enter valid email": "Enter valid email",
      "Please enter password": "Please enter password",
      "Password must be at least 6 characters":
      "Password must be at least 6 characters",
      "Password": "Password",
      "Enter valid password": "Enter valid password",
      "Login": "Login",
      "Forgot Password?": "Forgot Password?",
      "Reset": "Reset",
      "Don't have an account?": "Don't have an account?",
      "Sign Up": "Sign Up",
      "Create your account": "Create your account",
      "Please enter name": "Please enter name",
      "Name": "Name",
      "Please enter phone number": "Please enter phone number",
      "Please enter valid phone number": "Please enter valid phone number",
      "Phone Number": "Phone Number",
      "Confirm Password": "Confirm Password",
      "Already have an account?": "Already have an account?",
      "Sign In": "Sign In",
      "Likes": "Likes",
      "Share": "Share",
      "Edit Profile": "Edit Profile",
      "My Products": "My Products",
    },
    //   sindhi
    Utils.getLanguageCode('Sindhi'): {
      'Text Extractor App': 'ٽيڪسٽ ايگزٽر ايپ',
      'hello': 'هيلو',
      'Not Yet Scanned': 'اڃا تائين اسڪين ٿيل ناهي',
      'Welcome': 'خوش آمديد',
      "QR Code Scanner": " ڪيو آر ڪوڊاسڪينر",
      'Scan QR Code': 'QR ڪوڊ اسڪين ڪريو',
      'Scan the QR code to get the details': 'تفصيل حاصل ڪرڻ لاء QR ڪوڊ اسڪين ڪريو',
      "Recent Transactions": "هاڻي جي ٽرانزيڪشن",
      'language': 'زبان',
      'Balance': 'بيلنس',
      'select_language': 'زبان چونڊيو',
      'Account Number': 'اڪائونٽ نمبر',
      'Send Money': 'پئسا موڪليو',
      'Add Money': 'پئسا شامل ڪريو',
      'select_image': 'عڪس چونڊيو',
      'translate': 'ترجمو ڪريو',
      'translate_text': 'متن ترجمو ڪريو',
      'translate_image': 'عڪس ترجمو ڪريو',
      'translate_text_image': 'متن / عڪس ترجمو ڪريو',
      'translate_text_image_desc': 'عڪس کان متن ترجمو ڪريو',
      'translate_text_desc': 'متن ترجمو ڪريو',
      'translate_image_desc': 'عڪس ترجمو ڪريو',
      'Type a message': 'پيغام لکو',
      'Select Image': 'تصوير چونڊيو',
      'Camera': 'ڪئميرا',
      'Gallery': 'گيلري',
      'Vehicle Number': 'گاڏي جو نمبر',
      'Vehicle': 'گاڏي',
      'Vehicle Type': 'گاڏي جي قسم',
      'Vehicle Model': 'گاڏين جو ماڊل',
      'Choose Language': ' ٻولي چونڊيو',
      'Home': 'هوم',
      'Search': 'ڳوليو',
      'Profile': 'پروفائل',
      'QrCode': 'ڪيو آر ڪوڊ',
      'Choose Category': 'پسند ڪيو(چونڊيو)',
      'Sindhi': 'سنڌي',
      'Hindi': 'هندي',
      'Spanish': 'اسپينش',
      'French': 'فرانسيسي',
      "English": "انگريزي",
      'Arabic': 'عربي',
      'Trustee': 'اعتماد واري',
      'Categories': 'پسند ڪيو(چونڊيو)',
      'View All': 'سڀ ڏسو',
      'Electronics': 'اليڪٽرانڪس',
      'Real Estate': 'ريئل اسٽيٽ',
      'Jobs': 'نوڪريون',
      "Vehicles": "گاڏيون",
      'Logout': ' لاگ آئوٽ ڪريو',
      "Settings": "سيٽنگ",
      "Mobiles": "موبائلز",
      "Home Appliances": "گھر جو سامان",
      "Bikes": "بائيڪس",
      'Catagories': 'پسند ڪيو(چونڊيو)',
      "Property": "جائيداد",
      "Services": "خدمتون",
      "Others": "ٻيا",
      "Furniture": "فرنيچر",
      "Fashion & Beauty": "فيشن ۽ خوبصورتي",
      "Books & Sports": "ڪتابن ۽ اسپورٽس",
      "Kids": "ٻارن",
      "Business": "ڪاروبار",
      "Login to your account": "اڪائونٽ ۾ لاگ ان ڪريو",
      "Please enter valid email": "مهرباني ڪري صحيح اي ميل داخل ڪريو",
      "Please enter email": "مهرباني ڪري اي ميل داخل ڪريو",
      "Email": "اي ميل",
      "Enter valid email": "صحيح اي ميل داخل ڪريو",
      "Please enter password": "مهرباني ڪري پاس ورڊ داخل ڪريو",
      "Password must be at least 6 characters":
      "پاسورڊ گهٽ ۾ گهٽ 6 حرفن جو هجڻ گهرجي",
      "Password": "پاس ورڊ",
      "Enter valid password": "صحيح پاس ورڊ داخل ڪريو",
      "Login": "لاگ ان ڪريو",
      "Forgot Password?": "توھان پاسورڊ وساري ڇڏيو؟",
      "Reset": "ري سيٽ ڪريو",
      "Don't have an account?": "اڪائونٽ نه آهي؟",
      "Sign Up": "سائن اپ ڪيو",
      "Create your account": "پنهنجو اڪائونٽ ٺاهيو",
      "Please enter name": "مهرباني ڪري نالو داخل ڪريو",
      "Name": "نالو",
      "Please enter phone number": "مهرباني ڪري فون نمبر داخل ڪريو",
      "Please enter valid phone number":
      "مهرباني ڪري صحيح فون نمبر داخل ڪريو",
      "Phone Number": "فون نمبر",
      "Confirm Password": "پاسورڊ جي تصديق ڪريو",
      "Already have an account?": "اڳ ۾ ئي هڪ اڪائونٽ آهي؟",
      "SignIn": "سائن ان ڪريو",
      "Likes": "لائڪس",
      "Share": "شيئر ڪريو",
      "Edit Profile": "پروفائل سنجيدڻ",
      "My Products": "منهنجي پنهنجي مصنوعات",
    },
    //   hindi
    Utils.getLanguageCode('Hindi'): {
      'hello': 'नमस्ते दुनिया',
      "Welcome": "स्वागत है",
      'language': 'भाषा',
      'Not Yet Scanned': 'अभी तक स्कैन नहीं किया गया है',
      "QR Code Scanner": "क्यूआर कोड स्कैनर",
      'Scan QR Code': 'क्यूआर कोड स्कैन करें',
      'Scan the QR code to get the details': 'विवरण प्राप्त करने के लिए QR कोड स्कैन करें',
      "Recent Transactions": "हाल की लेन-देन",
      'Balance': 'शेष',
      'Send Money': 'पैसे भेजें',
      'Add Money': 'पैसे जोड़ें',
      'select_language': 'भाषा चुनिए',
      'Account Number': 'खाता संख्या',
      'Choose Language': 'भाषा चुनिए',
      'select_image': 'छवि चुनिए',
      'translate': 'अनुवाद करना',
      'translate_text': 'टेक्स्ट अनुवाद करें',
      'translate_image': 'छवि अनुवाद करें',
      'translate_text_image': 'टेक्स्ट / छवि अनुवाद करें',
      'translate_text_image_desc': 'छवि से पाठ अनुवाद करें',
      'translate_text_desc': 'टेक्स्ट अनुवाद करें',
      'translate_image_desc': 'छवि अनुवाद करें',
      'Type a message': 'एक संदेश टाइप करें',
      'Select Image': 'छवि चुनिए',
      'Home': 'होम',
      'Search': 'खोज',
      'Profile': 'प्रोफ़ाइल',
      'QR Code': 'क्यूआर कोड',
      'Camera': 'कैमरा',
      'Gallery': 'गैलरी',
      "English": "अंग्रेज़ी",
      'Arabic': 'अरबी',
      'Sindhi': 'सिंधी',
      'Hindi': 'हिंदी',
      'Spanish': 'स्पेनिश',
      'French': 'फ्रेंच',
      'Trustee': 'ट्रस्टी',
      'Categories': 'श्रेणियाँ',
      'View All': 'सभी देखें',
      'Electronics': 'इलेक्ट्रॉनिक्स',
      'Real Estate': 'रियल एस्टेट',
      'Jobs': 'नौकरियां',
      "Vehicles": "वाहन",
      'Logout': 'लॉग आउट',
      "Settings": "सेटिंग्स",
      "Mobiles": "मोबाइल",
      "Home Appliances": "घरेलू उपकरण",
      "Bikes": "बाइक",
      "Catagories": "श्रेणियाँ",
      "Property": "संपत्ति",
      'Services': 'सेवाएं',
      "Other": "अन्य",
      "Furniture": "फर्नीचर",
      "Fashion & Beauty": "फैशन और सौंदर्य",
      "Books & Sports": "पुस्तकें और खेल",
      "Kids": "बच्चे",
      "Business": "व्यापार",
      "Login to your account": "अपने खाते में लॉगिन करें",
      "Please enter valid email": "कृपया वैध ईमेल दर्ज करें",
      "Please enter email": "कृपया ईमेल दर्ज करें",
      "Email": "ईमेल",
      "Enter valid email": "वैध ईमेल दर्ज करें",
      "Please enter password": "कृपया पासवर्ड दर्ज करें",
      "Password must be at least 6 characters":
      "पासवर्ड कम से कम 6 वर्ण होना चाहिए",
      "Password": "पासवर्ड",
      "Enter valid password": "वैध पासवर्ड दर्ज करें",
      "Login": "लॉग इन करें",
      "Forgot Password?": "पासवर्ड भूल गए?",
      "Reset": "रीसेट",
      "Don't have an account?": "खाता नहीं है?",
      "Sign Up": "साइन अप करें",
      "Create your account": "अपना खाता बनाएं",
      "Please enter name": "कृपया नाम दर्ज करें",
      "Name": "नाम",
      "Please enter phone number": "कृपया फ़ोन नंबर दर्ज करें",
      "Please enter valid phone number": "कृपया वैध फ़ोन नंबर दर्ज करें",
      "Phone Number": "फ़ोन नंबर",
      "Confirm Password": "पासवर्ड की पुष्टि कीजिये",
      "Already have an account?": "पहले से ही एक खाता है?",
      "Sign In": "साइन इन करें",
      "Likes": "पसंद",
      "Share": "शेयर",
      "Edit Profile": "प्रोफ़ाइल संपादित करें",
      "My Products": "मेरे उत्पाद",
    },

    //  arbi
    Utils.getLanguageCode('Arabic'): {
      'Text Extractor App': 'تطبيق مستخرج النص',
      'Type a message': 'اكتب رسالة',
      'hello': 'مرحبا بالعالم',
      'language': 'لغة',
      'Not Yet Scanned': 'لم يتم المسح بعد',
      'Welcome': 'أهلا بك',
      "QR Code Scanner": "ماسح رمز الاستجابة السريعة",
      'Scan QR Code': 'مسح رمز الاستجابة السريعة',
      'Scan the QR code to get the details': 'مسح رمز الاستجابة السريعة للحصول على التفاصيل',
      "Recent Transactions": "المعاملات الأخيرة",
      'Balance': 'توازن',
      'Send Money': 'إرسال المال',
      'Add Money': 'إضافة المال',
      'Choose Language': 'اختر اللغة',
      'Home': 'الصفحة الرئيسية',
      'Search': 'بحث',
      'Profile': 'الملف الشخصي',
      'select_language': 'اختر اللغة',
      'select_image': 'اختر صورة',
      'Account Number': 'رقم الحساب',
      'translate': 'ترجمة',
      'translate_text': 'ترجمة النص',
      'translate_image': 'ترجمة الصورة',
      'translate_text_image': 'ترجمة النص / الصورة',
      'translate_text_image_desc': 'ترجمة النص من الصورة',
      'translate_text_desc': 'ترجمة النص',
      'translate_image_desc': 'ترجمة الصورة',
      'Select Image': 'اختر صورة',
      'Camera': 'آلة تصوير',
      'Gallery': 'صالة عرض',
      'QR Code': 'رمز الاستجابة السريعة',
      'Sindhi': 'السندي',
      'Hindi': 'الهندي',
      'Spanish': 'الأسبانية',
      'French': 'الفرنسية',
      "English": "الإنجليزية",
      'Arabic': 'عربى',
      'Trustee': 'المستفيد',
      'Categories': 'التصنيفات',
      'View All': 'عرض الكل',
      'Electronics': 'إلكترونيات',
      'Real Estate': 'العقارات',
      'Jobs': 'وظائف',
      "Vehicles": "المركبات",
      'Logout': 'تسجيل خروج',
      "Settings": "الإعدادات",
      "Mobiles": " جوا ل ",
      "Home Appliances": "أجهزة منزلية",
      "Bikes": "دراجات نارية",
      "Catagories": "التصنيفات",
      "Property": "ملكية",
      'Services': 'خدمات',
      "Other": "آخر",
      "Furniture": "أثاث",
      "Fashion & Beauty": "الموضة والجمال",
      "Books & Sports": "الكتب والرياضة",
      "Kids": "أطفال",
      "Business": "أعمال",
      "Login to your account": "تسجيل الدخول إلى حسابك",
      "Please enter valid email": "الرجاء إدخال بريد إلكتروني صالح",
      "Please enter email": "الرجاء إدخال البريد الإلكتروني",
      "Email": "البريد الإلكتروني",
      "Enter valid email": "أدخل بريد إلكتروني صالح",
      "Please enter password": "الرجاء إدخال كلمة المرور",
      "Password must be at least 6 characters":
      "يجب أن تتكون كلمة المرور من 6 أحرف على الأقل",
      "Password": "كلمه السر",
      "Enter valid password": "أدخل كلمة مرور صالحة",
      "Login": "تسجيل الدخول",
      "Forgot Password?": "هل نسيت كلمة المرور؟",
      "Reset": "إعادة تعيين",
      "Don't have an account?": "ليس لديك حساب؟",
      "Sign Up": "سجل",
      "Create your account": "انشئ حسابك",
      "Please enter name": "الرجاء إدخال الاسم",
      "Name": "اسم",
      "Please enter phone number": "الرجاء إدخال رقم الهاتف",
      "Please enter valid phone number": "الرجاء إدخال رقم هاتف صالح",
      "Phone Number": "رقم الهاتف",
      "Confirm Password": "تأكيد كلمة المرور",
      "Already have an account?": "هل لديك حساب؟",
      "Sign In": "تسجيل الدخول",
      "Likes": "إعجابات",
      "Share": "شارك",
      "Edit Profile": "تعديل الملف الشخصي",
      "My Products": "منتجاتي",
    },
    //  spanish
    Utils.getLanguageCode('Spanish'): {
      'hello': 'Hola Mundo',
      'language': 'Idioma',
      'select_language': 'Seleccionar idioma',
      'select_image': 'Seleccionar imagen',
      'translate': 'Traducir',
      'translate_text': 'Traducir texto',
      'translate_image': 'Traducir imagen',
      'translate_text_image': 'Traducir texto / imagen',
      'translate_text_image_desc': 'Traducir texto de la imagen',
      'translate_text_desc': 'Traducir texto',
      'translate_image_desc': 'Traducir imagen',
      'Type a message': 'Escribe un mensaje',
      'Select Image': 'Seleccionar imagen',
      'Camera': 'Cámara',
      'Gallery': 'Galería',
      "Property": "Propiedad",
      'Services': 'Servicios',
      "Other": "Otro",
      "Furniture": "Mueble",
      "Fashion & Beauty": "Moda y belleza",
      "Books & Sports": "Libros y deportes",
      "Kids": "Niños",
      "Business": "Negocio",
      "Login to your account": "Inicia sesión en tu cuenta",
      "Please enter valid email":
      "Por favor ingrese un correo electrónico válido",
      "Please enter email": "Por favor ingrese el correo electrónico",
      "Email": "Email",
      "Enter valid email": "Ingrese un correo electrónico válido",
      "Please enter password": "Por favor ingrese la contraseña",
      "Password must be at least 6 characters":
      "La contraseña debe tener al menos 6 caracteres",
      "Password": "Contraseña",
      "Enter valid password": "Ingrese una contraseña válida",
      "Login": "Iniciar sesión",
      "Forgot Password?": "¿Se te olvidó tu contraseña?",
      "Reset": "Reiniciar",
      "Don't have an account?": "¿No tienes una cuenta?",
      "Sign Up": "Regístrate",
      "Create your account": "Crea tu cuenta",
      "Please enter name": "Por favor ingrese el nombre",
      "Name": "Nombre",
      "Please enter phone number":
      "Por favor ingrese el número de teléfono",
      "Please enter valid phone number":
      "Por favor ingrese un número de teléfono válido",
      "Phone Number": "Número de teléfono",
      "Confirm Password": "Confirmar contraseña",
      "Already have an account?": "¿Ya tienes una cuenta?",
      "Sign In": "Registrarse",
      "Share": "Compartir",
      "Edit Profile": "Editar perfil",
      "My Products": "Mis productos",
    },
    //  french
    Utils.getLanguageCode('French'): {
      'hello': 'Bonjour le monde',
      'language': 'Langue',
      'select_language': 'Choisir la langue',
      'select_image': 'Sélectionnez l\'image',
      'translate': 'Traduire',
      'translate_text': 'Traduire le texte',
      'translate_image': 'Traduire l\'image',
      'translate_text_image': 'Traduire le texte / l\'image',
      'translate_text_image_desc': 'Traduire le texte de l\'image',
      'translate_text_desc': 'Traduire le texte',
      'translate_image_desc': 'Traduire l\'image',
      'Type a message': 'Tapez un message',
      'Select Image': 'Sélectionnez l\'image',
      'Camera': 'Appareil photo',
      'Gallery': 'Galerie',
      "Property": "Propriété",
      'Services': 'Prestations de service',
      "Other": "Autre",
      "Furniture": "Meuble",
      "Fashion & Beauty": "Mode et beauté",
      "Books & Sports": "Livres et sports",
      "Kids": "Enfants",
      "Business": "Entreprise",
      "Login to your account": "Connectez-vous à votre compte",
      "Please enter valid email":
      "Veuillez saisir une adresse e-mail valide",
      "Please enter email": "Veuillez saisir l'adresse e-mail",
      "Email": "Email",
      "Enter valid email": "Entrez une adresse e-mail valide",
      "Please enter password": "Veuillez saisir le mot de passe",
      "Password must be at least 6 characters":
      "Le mot de passe doit comporter au moins 6 caractères",
      "Password": "Mot de passe",
      "Enter valid password": "Entrez un mot de passe valide",
      "Login": "S'identifier",
      "Forgot Password?": "Mot de passe oublié?",
      "Reset": "Réinitialiser",
      "Don't have an account?": "Vous n'avez pas de compte?",
      "Sign Up": "S'inscrire",
      "Create your account": "Créez votre compte",
      "Please enter name": "Veuillez saisir le nom",
      "Name": "Nom",
      "Please enter phone number": "Veuillez saisir le numéro de téléphone",
      "Please enter valid phone number":
      "Veuillez saisir un numéro de téléphone valide",
      "Phone Number": "Numéro de téléphone",
      "Confirm Password": "Confirmez le mot de passe",
      "Already have an account?": "Vous avez déjà un compte?",
      "Sign In": "Se connecter",
      "Likes": "Aime",
      "Share": "Partager",
      "Edit Profile": "Editer le profil",
      "My Products": "Mes produits",
    },
    //  german
    Utils.getLanguageCode('German'): {
      'hello': 'Hallo Welt',
      'language': 'Sprache',
      'select_language': 'Sprache auswählen',
      'select_image': 'Bild auswählen',
      'translate': 'Übersetzen',
      'translate_text': 'Text übersetzen',
      'translate_image': 'Bild übersetzen',
      'translate_text_image': 'Text / Bild übersetzen',
      'translate_text_image_desc': 'Text aus Bild übersetzen',
      'translate_text_desc': 'Text übersetzen',
      'translate_image_desc': 'Bild übersetzen',
      'Type a message': 'Gene Sie wine Trichina ein',
      'Select Image': 'Build auswählen',
      'Camera': 'Camera',
      'Gallery': 'Galleria',
      "Property": "Eigentum",
      "Services": "Dienstleistungen",
      "Other": "Andere",
      "Furniture": "Möbel",
      "Fashion & Beauty": "Mode und Schönheit",
      "Books & Sports": "Bücher und Sport",
      "Kids": "Kinder",
      "Business": "Geschäft",
      "Login to your account": "Melden Sie sich bei Ihrem Konto an",
      "Please enter valid email":
      "Bitte geben Sie eine gültige E-Mail-Adresse ein",
      "Please enter email": "Bitte geben Sie die E-Mail-Adresse ein",
      "Email": "Email",
      "Enter valid email": "Geben Sie eine gültige E-Mail-Adresse ein",
      "Please enter password": "Bitte geben Sie das Passwort ein",
      "Password must be at least 6 characters":
      "Das Passwort muss mindestens 6 Zeichen lang sein",
      "Password": "Passwort",
      "Enter valid password": "Geben Sie ein gültiges Passwort ein",
      "Login": "Anmeldung",
      "Forgot Password?": "Passwort vergessen?",
      "Reset": "Zurücksetzen",
      "Don't have an account?": "Sie haben noch keinen Account?",
      "Sign Up": "Anmelden",
      "Create your account": "Erstellen Sie Ihr Konto",
      "Please enter name": "Bitte geben Sie den Namen ein",
      "Name": "Name",
      "Please enter phone number": "Bitte geben Sie die Telefonnummer ein",
      "Please enter valid phone number":
      "Bitte geben Sie eine gültige Telefonnummer ein",
      "Phone Number": "Telefonnummer",
      "Confirm Password": "Bestätige das Passwort",
      "Already have an account?": "Sie haben bereits ein Konto?",
      "Sign In": "Einloggen",
      "Likes": "Likes",
      "Share": "Teilen",
      "Edit Profile": "Profil bearbeiten",
      "My Products": "Meine Produkte",
    },
  };
}