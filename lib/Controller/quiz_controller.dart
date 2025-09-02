import 'dart:math';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class QuizController extends GetxController {
  final storage = GetStorage();

  var currentQuestionIndex = 0.obs;
  var score = 0.obs;
  var showFeedback = false.obs;
  var feedbackMessage = ''.obs;
  var highScore = 0.obs;
  var selectedQuestions = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    highScore.value = storage.read('highScore') ?? 0;
    loadQuestions();
  }

  void loadQuestions() async {
    try {
      isLoading.value = true;
      selectedQuestions.value = await _getRandomQuestions(10);
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> _getRandomQuestions(int count) async {
    final random = Random();
    final List<Map<String, dynamic>> shuffledQuestions = List.from(questionBank)
      ..shuffle(random);
    return shuffledQuestions.take(count).toList();
  }

  void checkAnswer(String selectedOption) {
    if (selectedQuestions.isEmpty ||
        currentQuestionIndex.value >= selectedQuestions.length) {
      return;
    }
    showFeedback.value = true;
    if (selectedOption ==
        selectedQuestions[currentQuestionIndex.value]['correctAnswer']) {
      score.value++;
      feedbackMessage.value =
          "Correct! 🎉 ${selectedQuestions[currentQuestionIndex.value]['explanation']}";
    } else {
      feedbackMessage.value =
          "Oops, try again! 😊 ${selectedQuestions[currentQuestionIndex.value]['explanation']}";
    }
  }

  void nextQuestion() {
    showFeedback.value = false;
    feedbackMessage.value = '';
    currentQuestionIndex.value++;
    if (currentQuestionIndex.value == selectedQuestions.length) {
      if (score.value > highScore.value) {
        highScore.value = score.value;
        storage.write('highScore', highScore.value);
      }
    }
  }

  void resetQuiz() {
    currentQuestionIndex.value = 0;
    score.value = 0;
    showFeedback.value = false;
    feedbackMessage.value = '';
    loadQuestions(); // Reinitialize questions
  }
}

final List<Map<String, dynamic>> questionBank = [
  {
    "question": "What is the first Kalima called?",
    "questionUrdu": "پہلا کلمہ کیا کہلاتا ہے؟",
    "options": [
      "Kalima Tayyibah",
      "Kalima Shahadah",
      "Kalima Tamjeed",
      "Kalima Tawheed"
    ],
    "optionsUrdu": ["کلمہ طیبہ", "کلمہ شہادت", "کلمہ تمجید", "کلمہ توحید"],
    "correctAnswer": "Kalima Tayyibah",
    "correctAnswerUrdu": "کلمہ طیبہ",
    "explanation":
        "The first Kalima, Kalima Tayyibah, declares that there is no god but Allah and Muhammad is His messenger.",
    "explanationUrdu":
        "پہلا کلمہ، کلمہ طیبہ، اعلان کرتا ہے کہ اللہ کے سوا کوئی معبود نہیں اور محمد اس کے رسول ہیں۔"
  },
  {
    "question": "How many pillars of Islam are there?",
    "questionUrdu": "اسلام کے کتنے رکن ہیں؟",
    "options": ["4", "5", "6", "7"],
    "optionsUrdu": ["4", "5", "6", "7"],
    "correctAnswer": "5",
    "correctAnswerUrdu": "5",
    "explanation":
        "The five pillars of Islam are: Shahada, Salah, Zakat, Sawm, and Hajj.",
    "explanationUrdu":
        "اسلام کے پانچ رکن یہ ہیں: شہادت، نماز، زکوٰۃ، روزہ، اور حج۔"
  },
  {
    "question": "What is the holy book of Muslims?",
    "questionUrdu": "مسلمانوں کی مقدس کتاب کیا ہے؟",
    "options": ["Bible", "Torah", "Quran", "Vedas"],
    "optionsUrdu": ["بائبل", "تورات", "قرآن", "وید"],
    "correctAnswer": "Quran",
    "correctAnswerUrdu": "قرآن",
    "explanation":
        "The Quran is the holy book revealed to Prophet Muhammad (PBUH) by Allah through Angel Jibreel.",
    "explanationUrdu":
        "قرآن وہ مقدس کتاب ہے جو اللہ نے حضرت جبرائیل کے ذریعے نبی محمد صلی اللہ علیہ وسلم پر نازل کی۔"
  },
  {
    "question": "How many times do Muslims pray each day?",
    "questionUrdu": "مسلمان روزانہ کتنی بار نماز پڑھتے ہیں؟",
    "options": ["3", "4", "5", "6"],
    "optionsUrdu": ["3", "4", "5", "6"],
    "correctAnswer": "5",
    "correctAnswerUrdu": "5",
    "explanation":
        "Muslims pray five times daily: Fajr, Dhuhr, Asr, Maghrib, and Isha.",
    "explanationUrdu":
        "مسلمان دن میں پانچ وقت نماز پڑھتے ہیں: فجر، ظہر، عصر، مغرب، اور عشاء۔"
  },
  {
    "question":
        "What is the name of the angel who brought revelations to Prophet Muhammad (PBUH)?",
    "questionUrdu":
        "اس فرشتے کا نام کیا ہے جو نبی محمد صلی اللہ علیہ وسلم پر وحی لایا؟",
    "options": ["Mikail", "Israfil", "Jibreel", "Azrail"],
    "optionsUrdu": ["میکائیل", "اسرافیل", "جبرائیل", "عزرائیل"],
    "correctAnswer": "Jibreel",
    "correctAnswerUrdu": "جبرائیل",
    "explanation":
        "Angel Jibreel (Gabriel) brought the Quranic revelations from Allah to Prophet Muhammad (PBUH).",
    "explanationUrdu":
        "فرشتہ جبرائیل (جبریل) اللہ کی طرف سے قرآنی وحی نبی محمد صلی اللہ علیہ وسلم پر لایا۔"
  },
  {
    "question": "In which city was Prophet Muhammad (PBUH) born?",
    "questionUrdu": "نبی محمد صلی اللہ علیہ وسلم کس شہر میں پیدا ہوئے؟",
    "options": ["Medina", "Mecca", "Jerusalem", "Damascus"],
    "optionsUrdu": ["مدینہ", "مکہ", "یروشلم", "دمشق"],
    "correctAnswer": "Mecca",
    "correctAnswerUrdu": "مکہ",
    "explanation":
        "Prophet Muhammad (PBUH) was born in Mecca in the year 570 CE.",
    "explanationUrdu":
        "نبی محمد صلی اللہ علیہ وسلم 570 عیسوی میں مکہ میں پیدا ہوئے۔"
  },
  {
    "question": "What is the Arabic word for charity?",
    "questionUrdu": "خیرات کے لیے عربی لفظ کیا ہے؟",
    "options": ["Salah", "Zakat", "Hajj", "Sawm"],
    "optionsUrdu": ["صلوٰۃ", "زکوٰۃ", "حج", "صوم"],
    "correctAnswer": "Zakat",
    "correctAnswerUrdu": "زکوٰۃ",
    "explanation":
        "Zakat is obligatory charity that Muslims give to help the poor and needy.",
    "explanationUrdu":
        "زکوٰۃ لازمی خیرات ہے جو مسلمان غریبوں اور محتاجوں کی مدد کے لیے دیتے ہیں۔"
  },
  {
    "question": "Which month do Muslims fast?",
    "questionUrdu": "مسلمان کس مہینے میں روزہ رکھتے ہیں؟",
    "options": ["Muharram", "Ramadan", "Shawwal", "Dhul Hijjah"],
    "optionsUrdu": ["محرم", "رمضان", "شوال", "ذوالحجہ"],
    "correctAnswer": "Ramadan",
    "correctAnswerUrdu": "رمضان",
    "explanation":
        "Muslims fast during the month of Ramadan from dawn to sunset.",
    "explanationUrdu": "مسلمان رمضان کے مہینے میں صبح سے شام تک روزہ رکھتے ہیں۔"
  },
  {
    "question": "What is the direction Muslims face when praying?",
    "questionUrdu": "نماز پڑھتے وقت مسلمان کس سمت رخ کرتے ہیں؟",
    "options": ["North", "South", "Qibla", "East"],
    "optionsUrdu": ["شمال", "جنوب", "قبلہ", "مشرق"],
    "correctAnswer": "Qibla",
    "correctAnswerUrdu": "قبلہ",
    "explanation":
        "Muslims face the Qibla, which is the direction towards the Kaaba in Mecca.",
    "explanationUrdu":
        "مسلمان قبلہ کی طرف رخ کرتے ہیں، جو مکہ میں خانہ کعبہ کی سمت ہے۔"
  },
  {
    "question": "How many chapters (Surahs) are in the Quran?",
    "questionUrdu": "قرآن میں کتنے سورے (ابواب) ہیں؟",
    "options": ["110", "114", "120", "124"],
    "optionsUrdu": ["110", "114", "120", "124"],
    "correctAnswer": "114",
    "correctAnswerUrdu": "114",
    "explanation":
        "The Quran contains 114 chapters called Surahs, from Al-Fatiha to An-Nas.",
    "explanationUrdu": "قرآن میں 114 سورے ہیں جو الفاتحہ سے الناس تک ہیں۔"
  },
  {
    "question": "What is the first Surah in the Quran?",
    "questionUrdu": "قرآن کا پہلا سورہ کیا ہے؟",
    "options": ["Al-Baqarah", "Al-Fatiha", "Al-Ikhlas", "An-Nas"],
    "optionsUrdu": ["البقرہ", "الفاتحہ", "الاخلاص", "الناس"],
    "correctAnswer": "Al-Fatiha",
    "correctAnswerUrdu": "الفاتحہ",
    "explanation":
        "Al-Fatiha (The Opening) is the first chapter of the Quran and is recited in every prayer.",
    "explanationUrdu":
        "الفاتحہ (کھولنے والی) قرآن کا پہلا سورہ ہے اور ہر نماز میں پڑھا جاتا ہے۔"
  },
  {
    "question": "What does \"Bismillah\" mean?",
    "questionUrdu": "\"بسم اللہ\" کا کیا مطلب ہے؟",
    "options": [
      "Praise be to Allah",
      "In the name of Allah",
      "Allah is great",
      "There is no god but Allah"
    ],
    "optionsUrdu": [
      "اللہ کی تعریف",
      "اللہ کے نام سے",
      "اللہ سب سے بڑا ہے",
      "اللہ کے سوا کوئی معبود نہیں"
    ],
    "correctAnswer": "In the name of Allah",
    "correctAnswerUrdu": "اللہ کے نام سے",
    "explanation":
        "Bismillah means \"In the name of Allah\" and Muslims say it before starting any task.",
    "explanationUrdu":
        "بسم اللہ کا مطلب \"اللہ کے نام سے\" ہے اور مسلمان کوئی بھی کام شروع کرنے سے پہلے یہ کہتے ہیں۔"
  },
  {
    "question": "Who was the first Caliph after Prophet Muhammad (PBUH)?",
    "questionUrdu": "نبی محمد صلی اللہ علیہ وسلم کے بعد پہلے خلیفہ کون تھے؟",
    "options": ["Ali (RA)", "Umar (RA)", "Uthman (RA)", "Abu Bakr (RA)"],
    "optionsUrdu": [
      "علی رضی اللہ عنہ",
      "عمر رضی اللہ عنہ",
      "عثمان رضی اللہ عنہ",
      "ابوبکر رضی اللہ عنہ"
    ],
    "correctAnswer": "Abu Bakr (RA)",
    "correctAnswerUrdu": "ابوبکر رضی اللہ عنہ",
    "explanation":
        "Abu Bakr (RA) was the first Caliph and the closest companion of Prophet Muhammad (PBUH).",
    "explanationUrdu":
        "ابوبکر رضی اللہ عنہ پہلے خلیفہ اور نبی محمد صلی اللہ علیہ وسلم کے سب سے قریبی ساتھی تھے۔"
  },
  {
    "question": "What is the night journey of Prophet Muhammad (PBUH) called?",
    "questionUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کے رات کے سفر کو کیا کہتے ہیں؟",
    "options": ["Hijra", "Isra and Miraj", "Laylat al-Qadr", "Mawlid"],
    "optionsUrdu": ["ہجرت", "اسراء و معراج", "لیلۃ القدر", "میلاد"],
    "correctAnswer": "Isra and Miraj",
    "correctAnswerUrdu": "اسراء و معراج",
    "explanation":
        "Isra and Miraj refers to the miraculous night journey of Prophet Muhammad (PBUH) from Mecca to Jerusalem and then to the heavens.",
    "explanationUrdu":
        "اسراء و معراج نبی محمد صلی اللہ علیہ وسلم کے معجزاتی رات کے سفر کو کہتے ہیں جو مکہ سے یروشلم اور پھر آسمانوں تک تھا۔"
  },
  {
    "question":
        "Which wife of Prophet Muhammad (PBUH) was called \"Mother of the Believers\"?",
    "questionUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کی کون سی بیوی کو \"مؤمنوں کی ماں\" کہا جاتا تھا؟",
    "options": ["Khadija (RA)", "Aisha (RA)", "Hafsa (RA)", "All of them"],
    "optionsUrdu": [
      "خدیجہ رضی اللہ عنہا",
      "عائشہ رضی اللہ عنہا",
      "حفصہ رضی اللہ عنہا",
      "سب"
    ],
    "correctAnswer": "All of them",
    "correctAnswerUrdu": "سب",
    "explanation":
        "All wives of Prophet Muhammad (PBUH) are called \"Mothers of the Believers\" (Ummahaat al-Mu'mineen).",
    "explanationUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کی تمام بیویوں کو \"امہات المؤمنین\" (مؤمنوں کی مائیں) کہا جاتا ہے۔"
  },
  {
    "question": "What is the Islamic greeting?",
    "questionUrdu": "اسلامی سلام کیا ہے؟",
    "options": ["Hello", "Good morning", "Assalamu Alaikum", "Namaste"],
    "optionsUrdu": ["ہیلو", "صبح بخیر", "السلام علیکم", "نمسکار"],
    "correctAnswer": "Assalamu Alaikum",
    "correctAnswerUrdu": "السلام علیکم",
    "explanation":
        "Assalamu Alaikum means \"Peace be upon you\" and is the Islamic greeting.",
    "explanationUrdu":
        "السلام علیکم کا مطلب \"آپ پر سلامتی ہو\" ہے اور یہ اسلامی سلام ہے۔"
  },
  {
    "question": "How many years did it take for the Quran to be revealed?",
    "questionUrdu": "قرآن کا نزول کتنے سالوں میں مکمل ہوا؟",
    "options": ["20 years", "23 years", "25 years", "30 years"],
    "optionsUrdu": ["20 سال", "23 سال", "25 سال", "30 سال"],
    "correctAnswer": "23 years",
    "correctAnswerUrdu": "23 سال",
    "explanation":
        "The Quran was revealed over a period of 23 years during the prophethood of Muhammad (PBUH).",
    "explanationUrdu":
        "قرآن 23 سال کی مدت میں محمد صلی اللہ علیہ وسلم کی نبوت کے دوران نازل ہوا۔"
  },
  {
    "question": "What is the cube-shaped building in Mecca called?",
    "questionUrdu": "مکہ میں مکعب کی شکل کی عمارت کو کیا کہتے ہیں؟",
    "options": ["Mosque", "Kaaba", "Minaret", "Dome"],
    "optionsUrdu": ["مسجد", "کعبہ", "مینار", "گنبد"],
    "correctAnswer": "Kaaba",
    "correctAnswerUrdu": "کعبہ",
    "explanation":
        "The Kaaba is the cube-shaped building in Mecca that Muslims face during prayer and visit during Hajj.",
    "explanationUrdu":
        "کعبہ مکہ میں مکعب کی شکل کی عمارت ہے جس کی طرف مسلمان نماز میں رخ کرتے ہیں اور حج کے دوران اس کی زیارت کرتے ہیں۔"
  },
  {
    "question": "Which prophet is known as the \"Friend of Allah\"?",
    "questionUrdu": "کون سے نبی کو \"اللہ کا دوست\" کہا جاتا ہے؟",
    "options": ["Musa (AS)", "Isa (AS)", "Ibrahim (AS)", "Nuh (AS)"],
    "optionsUrdu": [
      "موسیٰ علیہ السلام",
      "عیسیٰ علیہ السلام",
      "ابراہیم علیہ السلام",
      "نوح علیہ السلام"
    ],
    "correctAnswer": "Ibrahim (AS)",
    "correctAnswerUrdu": "ابراہیم علیہ السلام",
    "explanation":
        "Prophet Ibrahim (Abraham) is called \"Khalilullah\" meaning the Friend of Allah.",
    "explanationUrdu":
        "نبی ابراہیم علیہ السلام کو \"خلیل اللہ\" کہا جاتا ہے جس کا مطلب اللہ کا دوست ہے۔"
  },
  {
    "question": "What is the last Surah in the Quran?",
    "questionUrdu": "قرآن کا آخری سورہ کیا ہے؟",
    "options": ["Al-Falaq", "An-Nas", "Al-Ikhlas", "Al-Kawthar"],
    "optionsUrdu": ["الفلق", "الناس", "الاخلاص", "الکوثر"],
    "correctAnswer": "An-Nas",
    "correctAnswerUrdu": "الناس",
    "explanation":
        "Surah An-Nas (Mankind) is the 114th and final chapter of the Quran.",
    "explanationUrdu": "سورہ الناس (انسان) قرآن کا 114واں اور آخری سورہ ہے۔"
  },
  {
    "question": "Who was the mother of Prophet Isa (Jesus)?",
    "questionUrdu": "نبی عیسیٰ علیہ السلام کی والدہ کون تھیں؟",
    "options": ["Maryam (AS)", "Fatimah (RA)", "Khadija (RA)", "Aisha (RA)"],
    "optionsUrdu": [
      "مریم علیہا السلام",
      "فاطمہ رضی اللہ عنہا",
      "خدیجہ رضی اللہ عنہا",
      "عائشہ رضی اللہ عنہا"
    ],
    "correctAnswer": "Maryam (AS)",
    "correctAnswerUrdu": "مریم علیہا السلام",
    "explanation":
        "Maryam (Mary) was the mother of Prophet Isa (Jesus) and is highly respected in Islam.",
    "explanationUrdu":
        "مریم علیہا السلام نبی عیسیٰ علیہ السلام کی والدہ تھیں اور اسلام میں بہت معزز ہیں۔"
  },
  {
    "question": 'What does "Insha Allah" mean?',
    "questionUrdu": 'انشاء اللہ کا کیا مطلب ہے؟',
    "options": ['Thank God', 'God willing', 'Praise God', 'God is great'],
    "optionsUrdu": [
      'اللہ کا شکر',
      'اللہ چاہے تو',
      'اللہ کی تعریف',
      'اللہ بہت بڑا ہے'
    ],
    "correctAnswer": 'God willing',
    "correctAnswerUrdu": 'اللہ چاہے تو',
    "explanation":
        'Insha Allah means "God willing" and expresses hope that Allah will make something happen.',
    "explanationUrdu":
        'انشاء اللہ کا مطلب "اللہ چاہے تو" ہے اور یہ امید ظاہر کرتا ہے کہ اللہ کچھ ہونے دے گا۔'
  },
  {
    "question": 'Which prophet built the ark?',
    "questionUrdu": 'کس نبی نے کشتی بنائی؟',
    "options": ['Ibrahim (AS)', 'Musa (AS)', 'Nuh (AS)', 'Yusuf (AS)'],
    "optionsUrdu": [
      'ابراہیم علیہ السلام',
      'موسیٰ علیہ السلام',
      'نوح علیہ السلام',
      'یوسف علیہ السلام'
    ],
    "correctAnswer": 'Nuh (AS)',
    "correctAnswerUrdu": 'نوح علیہ السلام',
    "explanation":
        'Prophet Nuh (Noah) built the ark to save believers and animals from the great flood.',
    "explanationUrdu":
        'حضرت نوح علیہ السلام نے عظیم سیلاب سے مومنین اور جانوروں کو بچانے کے لیے کشتی بنائی۔'
  },
  {
    "question": 'What is the pilgrimage to Mecca called?',
    "questionUrdu": 'مکہ کی زیارت کو کیا کہتے ہیں؟',
    "options": ['Umrah', 'Hajj', 'Ziyarah', 'Tawaf'],
    "optionsUrdu": ['عمرہ', 'حج', 'زیارت', 'طواف'],
    "correctAnswer": 'Hajj',
    "correctAnswerUrdu": 'حج',
    "explanation":
        'Hajj is the major pilgrimage to Mecca that Muslims must perform once in their lifetime if able.',
    "explanationUrdu":
        'حج مکہ کی بڑی زیارت ہے جو مسلمانوں پر زندگی میں ایک بار فرض ہے اگر وہ اس کی استطاعت رکھتے ہوں۔'
  },
  {
    "question": 'How many Rakats are in Fajr prayer?',
    "questionUrdu": 'فجر کی نماز میں کتنی رکعتیں ہیں؟',
    "options": ['2', '3', '4', '5'],
    "optionsUrdu": ['٢', '٣', '٤', '٥'],
    "correctAnswer": '2',
    "correctAnswerUrdu": '٢',
    "explanation":
        'Fajr prayer consists of 2 Rakats (units of prayer) performed before sunrise.',
    "explanationUrdu":
        'فجر کی نماز دو رکعت ہے جو طلوع آفتاب سے پہلے ادا کی جاتی ہے۔'
  },
  {
    "question": 'What is the Arabic term for the call to prayer?',
    "questionUrdu": 'نماز کی اذان کو عربی میں کیا کہتے ہیں؟',
    "options": ['Iqama', 'Adhan', 'Takbir', 'Tasbih'],
    "optionsUrdu": ['اقامہ', 'اذان', 'تکبیر', 'تسبیح'],
    "correctAnswer": 'Adhan',
    "correctAnswerUrdu": 'اذان',
    "explanation":
        'Adhan is the call to prayer announced five times a day from the mosque.',
    "explanationUrdu":
        'اذان نماز کی دعوت ہے جو مسجد سے دن میں پانچ بار دی جاتی ہے۔'
  },
  {
    "question": 'Which prophet could speak to animals?',
    "questionUrdu": 'کون سے نبی جانوروں سے بات کر سکتے تھے؟',
    "options": ['Sulaiman (AS)', 'Dawud (AS)', 'Yusuf (AS)', 'Harun (AS)'],
    "optionsUrdu": [
      'سلیمان علیہ السلام',
      'داؤد علیہ السلام',
      'یوسف علیہ السلام',
      'ہارون علیہ السلام'
    ],
    "correctAnswer": 'Sulaiman (AS)',
    "correctAnswerUrdu": 'سلیمان علیہ السلام',
    "explanation":
        'Prophet Sulaiman (Solomon) was given the ability to speak with animals and jinn.',
    "explanationUrdu":
        'حضرت سلیمان علیہ السلام کو جانوروں اور جنوں سے بات کرنے کی صلاحیت عطا کی گئی تھی۔'
  },
  {
    "question": 'What is the Islamic calendar based on?',
    "questionUrdu": 'اسلامی کیلنڈر کس پر مبنی ہے؟',
    "options": ['Sun', 'Moon', 'Stars', 'Seasons'],
    "optionsUrdu": ['سورج', 'چاند', 'ستارے', 'موسم'],
    "correctAnswer": 'Moon',
    "correctAnswerUrdu": 'چاند',
    "explanation":
        'The Islamic calendar is lunar-based, with months determined by the moon\'s phases.',
    "explanationUrdu":
        'اسلامی کیلنڈر قمری ہے، جس کے مہینے چاند کی کلاؤں کے مطابق طے ہوتے ہیں۔'
  },
  {
    "question": 'Which city is called the "City of the Prophet"?',
    "questionUrdu": 'کون سا شہر "مدینۃ النبی" کہلاتا ہے؟',
    "options": ['Mecca', 'Medina', 'Jerusalem', 'Baghdad'],
    "optionsUrdu": ['مکہ', 'مدینہ', 'بیت المقدس', 'بغداد'],
    "correctAnswer": 'Medina',
    "correctAnswerUrdu": 'مدینہ',
    "explanation":
        'Medina is called Madinat an-Nabi (City of the Prophet) because Prophet Muhammad (PBUH) lived there.',
    "explanationUrdu":
        'مدینہ کو مدینۃ النبی (نبی کا شہر) کہا جاتا ہے کیونکہ حضور صلی اللہ علیہ وسلم وہاں رہے۔'
  },
  {
    "question": 'What does "Alhamdulillah" mean?',
    "questionUrdu": 'الحمد للہ کا کیا مطلب ہے؟',
    "options": [
      'God is great',
      'In the name of God',
      'Praise be to Allah',
      'God willing'
    ],
    "optionsUrdu": [
      'اللہ بہت بڑا ہے',
      'اللہ کے نام سے',
      'اللہ کی تعریف',
      'اللہ چاہے تو'
    ],
    "correctAnswer": 'Praise be to Allah',
    "correctAnswerUrdu": 'اللہ کی تعریف',
    "explanation":
        'Alhamdulillah means "Praise be to Allah" and expresses gratitude to Allah.',
    "explanationUrdu":
        'الحمد للہ کا مطلب "اللہ کی تعریف" ہے اور یہ اللہ کے لیے شکر گزاری ظاہر کرتا ہے۔'
  },
  {
    "question":
        'How many sons did Prophet Ibrahim (AS) have mentioned in Quran?',
    "questionUrdu":
        'قرآن میں حضرت ابراہیم علیہ السلام کے کتنے بیٹوں کا ذکر ہے؟',
    "options": ['1', '2', '3', '4'],
    "optionsUrdu": ['١', '٢', '٣', '٤'],
    "correctAnswer": '2',
    "correctAnswerUrdu": '٢',
    "explanation":
        'Prophet Ibrahim (AS) had two sons: Ismail (AS) and Ishaq (AS).',
    "explanationUrdu":
        'حضرت ابراہیم علیہ السلام کے دو بیٹے تھے: اسماعیل علیہ السلام اور اسحاق علیہ السلام۔'
  },
  {
    "question": 'What is the night of power called in Arabic?',
    "questionUrdu": 'شب قدر کو عربی میں کیا کہتے ہیں؟',
    "options": [
      'Laylat al-Miraj',
      'Laylat al-Qadr',
      'Laylat al-Bara\'ah',
      'Laylat al-Isra'
    ],
    "optionsUrdu": [
      'لیلۃ المعراج',
      'لیلۃ القدر',
      'لیلۃ البراءت',
      'لیلۃ الاسراء'
    ],
    "correctAnswer": 'Laylat al-Qadr',
    "correctAnswerUrdu": 'لیلۃ القدر',
    "explanation":
        'Laylat al-Qadr (Night of Power) is when the first verses of Quran were revealed, occurring in the last 10 nights of Ramadan.',
    "explanationUrdu":
        'لیلۃ القدر (شب قدر) وہ رات ہے جب قرآن کی پہلی آیات نازل ہوئیں، یہ رمضان کی آخری دس راتوں میں سے ایک ہے۔'
  },
  {
    "question": 'Which angel will blow the trumpet on the Day of Judgment?',
    "questionUrdu": 'قیامت کے دن کون سا فرشتہ صور پھونکے گا؟',
    "options": ['Jibreel (AS)', 'Mikail (AS)', 'Israfil (AS)', 'Azrail (AS)'],
    "optionsUrdu": [
      'جبریل علیہ السلام',
      'میکائیل علیہ السلام',
      'اسرافیل علیہ السلام',
      'عزرائیل علیہ السلام'
    ],
    "correctAnswer": 'Israfil (AS)',
    "correctAnswerUrdu": 'اسرافیل علیہ السلام',
    "explanation":
        'Angel Israfil will blow the trumpet to announce the Day of Judgment.',
    "explanationUrdu":
        'حضرت اسرافیل علیہ السلام قیامت کے دن کی آمد کے لیے صور پھونکیں گے۔'
  },
  {
    "question": 'What is the first month of the Islamic calendar?',
    "questionUrdu": 'اسلامی کیلنڈر کا پہلا مہینہ کون سا ہے؟',
    "options": ['Ramadan', 'Muharram', 'Rajab', 'Shawwal'],
    "optionsUrdu": ['رمضان', 'محرم', 'رجب', 'شوال'],
    "correctAnswer": 'Muharram',
    "correctAnswerUrdu": 'محرم',
    "explanation":
        'Muharram is the first month of the Islamic calendar and one of the four sacred months.',
    "explanationUrdu":
        'محرم اسلامی کیلنڈر کا پہلا مہینہ ہے اور چار مقدس مہینوں میں سے ایک ہے۔'
  },
  {
    "question": 'Which prophet was swallowed by a whale?',
    "questionUrdu": 'کس نبی کو مچھلی نے نگل لیا تھا؟',
    "options": ['Musa (AS)', 'Yunus (AS)', 'Harun (AS)', 'Lut (AS)'],
    "optionsUrdu": [
      'موسیٰ علیہ السلام',
      'یونس علیہ السلام',
      'ہارون علیہ السلام',
      'لوط علیہ السلام'
    ],
    "correctAnswer": 'Yunus (AS)',
    "correctAnswerUrdu": 'یونس علیہ السلام',
    "explanation":
        'Prophet Yunus (Jonah) was swallowed by a large fish/whale and later rescued by Allah.',
    "explanationUrdu":
        'حضرت یونس علیہ السلام کو ایک بڑی مچھلی نے نگل لیا تھا اور بعد میں اللہ نے انہیں نجات دی۔'
  },
  {
    "question": 'What is the meaning of "Muslim"?',
    "questionUrdu": '"مسلم" کا کیا مطلب ہے؟',
    "options": [
      'Believer',
      'One who submits to Allah',
      'Worshipper',
      'Follower'
    ],
    "optionsUrdu": [
      'ایمان والا',
      'اللہ کے آگے جھکنے والا',
      'عبادت کرنے والا',
      'پیروکار'
    ],
    "correctAnswer": 'One who submits to Allah',
    "correctAnswerUrdu": 'اللہ کے آگے جھکنے والا',
    "explanation":
        'Muslim means "one who submits to Allah" - someone who surrenders their will to Allah.',
    "explanationUrdu":
        'مسلم کا مطلب "اللہ کے آگے جھکنے والا" ہے - وہ جو اپنی مرضی اللہ کے حوالے کر دے۔'
  },
  {
    "question":
        'How many times is the word "Allah" mentioned in Surah Al-Ikhlas?',
    "questionUrdu": 'سورہ اخلاص میں "اللہ" کا لفظ کتنی بار آیا ہے؟',
    "options": ['2', '3', '4', '5'],
    "optionsUrdu": ['٢', '٣', '٤', '٥'],
    "correctAnswer": '3',
    "correctAnswerUrdu": '٣',
    "explanation":
        'The word "Allah" appears three times in Surah Al-Ikhlas, which describes the oneness of Allah.',
    "explanationUrdu":
        'سورہ اخلاص میں "اللہ" کا لفظ تین بار آیا ہے، جو اللہ کی وحدانیت بیان کرتی ہے۔'
  },
  {
    "question": 'What is the Arabic word for paradise?',
    "questionUrdu": 'جنت کے لیے عربی لفظ کیا ہے؟',
    "options": ['Jannah', 'Jahannam', 'Dunya', 'Akhirah'],
    "optionsUrdu": ['جنت', 'جہنم', 'دنیا', 'آخرت'],
    "correctAnswer": 'Jannah',
    "correctAnswerUrdu": 'جنت',
    "explanation":
        'Jannah is the Arabic word for paradise, the eternal home for righteous Muslims.',
    "explanationUrdu":
        'جنت عربی لفظ ہے جو فردوس کے لیے استعمال ہوتا ہے، نیک مسلمانوں کا ابدی گھر۔'
  },
  {
    "question": 'Which prophet was given the Zabur (Psalms)?',
    "questionUrdu": 'کس نبی کو زبور دی گئی؟',
    "options": ['Musa (AS)', 'Isa (AS)', 'Dawud (AS)', 'Ibrahim (AS)'],
    "optionsUrdu": [
      'موسیٰ علیہ السلام',
      'عیسیٰ علیہ السلام',
      'داؤد علیہ السلام',
      'ابراہیم علیہ السلام'
    ],
    "correctAnswer": 'Dawud (AS)',
    "correctAnswerUrdu": 'داؤد علیہ السلام',
    "explanation":
        'Prophet Dawud (David) was given the Zabur (Psalms) as a holy book.',
    "explanationUrdu":
        'حضرت داؤد علیہ السلام کو زبور مقدس کتاب کے طور پر دی گئی۔'
  },
  {
    "question":
        'What is the migration of Prophet Muhammad (PBUH) from Mecca to Medina called?',
    "questionUrdu":
        'نبی صلی اللہ علیہ وسلم کی مکہ سے مدینہ کی ہجرت کو کیا کہتے ہیں؟',
    "options": ['Hijra', 'Isra', 'Miraj', 'Fatah'],
    "optionsUrdu": ['ہجرت', 'اسراء', 'معراج', 'فتح'],
    "correctAnswer": 'Hijra',
    "correctAnswerUrdu": 'ہجرت',
    "explanation":
        'Hijra refers to the migration of Prophet Muhammad (PBUH) and his followers from Mecca to Medina in 622 CE.',
    "explanationUrdu":
        'ہجرت سے مراد حضور صلی اللہ علیہ وسلم اور آپ کے ساتھیوں کی مکہ سے مدینہ کی ہجرت ہے جو ۶۲۲ عیسوی میں ہوئی۔'
  },
  {
    "question": 'How many articles of faith (Iman) are there in Islam?',
    "questionUrdu": 'اسلام میں ایمان کے کتنے رکن ہیں؟',
    "options": ['5', '6', '7', '8'],
    "optionsUrdu": ['٥', '٦', '٧', '٨'],
    "correctAnswer": '6',
    "correctAnswerUrdu": '٦',
    "explanation":
        'There are six articles of faith: belief in Allah, angels, holy books, prophets, Day of Judgment, and divine decree.',
    "explanationUrdu":
        'ایمان کے چھ رکن ہیں: اللہ پر ایمان، فرشتوں پر، آسمانی کتابوں پر، انبیاء پر، قیامت کے دن پر، اور تقدیر پر۔'
  },
  {
    "question": 'What is the shortest Surah in the Quran?',
    "questionUrdu": 'قرآن کی سب سے چھوٹی سورہ کون سی ہے؟',
    "options": ['Al-Fatiha', 'Al-Ikhlas', 'Al-Kawthar', 'An-Nasr'],
    "optionsUrdu": ['فاتحہ', 'اخلاص', 'کوثر', 'نصر'],
    "correctAnswer": 'Al-Kawthar',
    "correctAnswerUrdu": 'کوثر',
    "explanation":
        'Surah Al-Kawthar is the shortest chapter in the Quran with only 3 verses.',
    "explanationUrdu":
        'سورہ کوثر قرآن کی سب سے چھوٹی سورہ ہے جس میں صرف تین آیات ہیں۔'
  },
  {
    "question": 'Which prophet was known for his patience during great trials?',
    "questionUrdu": 'کون سے نبی اپنے صبر کے لیے مشہور تھے؟',
    "options": ['Ayyub (AS)', 'Yaqub (AS)', 'Yusuf (AS)', 'Zakariya (AS)'],
    "optionsUrdu": [
      'ایوب علیہ السلام',
      'یعقوب علیہ السلام',
      'یوسف علیہ السلام',
      'زکریا علیہ السلام'
    ],
    "correctAnswer": 'Ayyub (AS)',
    "correctAnswerUrdu": 'ایوب علیہ السلام',
    "explanation":
        'Prophet Ayyub (Job) is famous for his incredible patience during severe trials and hardships.',
    "explanationUrdu":
        'حضرت ایوب علیہ السلام اپنے عظیم صبر کے لیے مشہور ہیں جو انہوں نے سخت آزمائشوں میں دکھایا۔'
  },
  {
    "question": 'What does "Subhan Allah" mean?',
    "questionUrdu": 'سبحان اللہ کا کیا مطلب ہے؟',
    "options": [
      'Praise be to Allah',
      'Glory be to Allah',
      'Allah is great',
      'Allah is one'
    ],
    "optionsUrdu": [
      'اللہ کی تعریف',
      'اللہ کی پاکی',
      'اللہ بہت بڑا ہے',
      'اللہ ایک ہے'
    ],
    "correctAnswer": 'Glory be to Allah',
    "correctAnswerUrdu": 'اللہ کی پاکی',
    "explanation":
        'Subhan Allah means "Glory be to Allah" and expresses the perfection and purity of Allah.',
    "explanationUrdu":
        'سبحان اللہ کا مطلب "اللہ کی پاکی" ہے اور یہ اللہ کی کمال اور پاکیزگی کا اظہار ہے۔'
  },
  {
    "question": 'Which Surah is known as the heart of the Quran?',
    "questionUrdu": 'کون سی سورہ کو قرآن کا دل کہا جاتا ہے؟',
    "options": ['Al-Fatiha', 'Ya-Sin', 'Al-Baqarah', 'Al-Ikhlas'],
    "optionsUrdu": ['فاتحہ', 'یٰسین', 'بقرہ', 'اخلاص'],
    "correctAnswer": 'Ya-Sin',
    "correctAnswerUrdu": 'یٰسین',
    "explanation":
        'Surah Ya-Sin is often called the heart of the Quran due to its central message and virtues.',
    "explanationUrdu":
        'سورہ یٰسین کو اکثر قرآن کا دل کہا جاتا ہے اس کے مرکزی پیغام اور فضائل کی وجہ سے۔'
  },
  {
    "question": 'What is the Arabic term for the Day of Judgment?',
    "questionUrdu": 'قیامت کے دن کے لیے عربی اصطلاح کیا ہے؟',
    "options": [
      'Yawm al-Qiyamah',
      'Yawm al-Jumu\'ah',
      'Yawm al-Arafah',
      'Yawm al-Ashura'
    ],
    "optionsUrdu": ['یوم القیامہ', 'یوم الجمعہ', 'یوم عرفہ', 'یوم عاشورا'],
    "correctAnswer": 'Yawm al-Qiyamah',
    "correctAnswerUrdu": 'یوم القیامہ',
    "explanation":
        'Yawm al-Qiyamah means the Day of Resurrection/Judgment when all will be held accountable.',
    "explanationUrdu":
        'یوم القیامہ کا مطلب قیامت/حساب کا دن ہے جب تمام لوگوں سے حساب کتاب ہوگا۔'
  },
  {
    "question":
        "Which companion of Prophet Muhammad (PBUH) was known as \"Al-Farooq\"?",
    "questionUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کے کون سے صحابی کو \"الفاروق\" کہا جاتا تھا؟",
    "options": ["Abu Bakr (RA)", "Umar (RA)", "Uthman (RA)", "Ali (RA)"],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "عمر (رضی اللہ عنہ)",
      "عثمان (رضی اللہ عنہ)",
      "علی (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Umar (RA)",
    "correctAnswerUrdu": "عمر (رضی اللہ عنہ)",
    "explanation":
        "Umar ibn al-Khattab (RA) was called \"Al-Farooq\" meaning \"the one who distinguishes between right and wrong\".",
    "explanationUrdu":
        "عمر بن خطاب (رضی اللہ عنہ) کو \"الفاروق\" کہا جاتا تھا جس کا مطلب ہے \"وہ جو حق اور باطل کے درمیان فرق کرتا ہے\"۔"
  },
  {
    "question": "What is the term for the pre-dawn meal during Ramadan?",
    "questionUrdu": "رمضان میں سحری کے کھانے کو کیا کہتے ہیں؟",
    "options": ["Iftar", "Suhur", "Qiyam", "Tarawih"],
    "optionsUrdu": ["افطار", "سحور", "قیام", "تراویح"],
    "correctAnswer": "Suhur",
    "correctAnswerUrdu": "سحور",
    "explanation":
        "Suhur is the pre-dawn meal that Muslims eat before beginning their fast during Ramadan.",
    "explanationUrdu":
        "سحور وہ کھانا ہے جو مسلمان رمضان میں روزہ شروع کرنے سے پہلے سحر کے وقت کھاتے ہیں۔"
  },
  {
    "question": "Which prophet was thrown into a fire but was saved by Allah?",
    "questionUrdu": "کون سا نبی آگ میں پھینکا گیا تھا لیکن اللہ نے اسے بچایا؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Harun (AS)", "Lut (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "ہارون (علیہ السلام)",
      "لوط (علیہ السلام)"
    ],
    "correctAnswer": "Ibrahim (AS)",
    "correctAnswerUrdu": "ابراہیم (علیہ السلام)",
    "explanation":
        "Prophet Ibrahim (AS) was thrown into a fire by King Nimrod, but Allah made the fire cool and safe for him.",
    "explanationUrdu":
        "نبی ابراہیم (علیہ السلام) کو بادشاہ نمرود نے آگ میں پھینکا تھا، لیکن اللہ نے آگ کو ٹھنڈا اور محفوظ بنا دیا۔"
  },
  {
    "question": "How many doors does Jannah (Paradise) have?",
    "questionUrdu": "جنت کے کتنے دروازے ہیں؟",
    "options": ["7", "8", "9", "10"],
    "optionsUrdu": ["7", "8", "9", "10"],
    "correctAnswer": "8",
    "correctAnswerUrdu": "8",
    "explanation":
        "Jannah has eight doors, each named after different righteous deeds that lead people to enter through them.",
    "explanationUrdu":
        "جنت کے آٹھ دروازے ہیں، ہر ایک کا نام مختلف نیک اعمال کے نام پر رکھا گیا ہے جو لوگوں کو ان سے داخل ہونے کی طرف لے جاتے ہیں۔"
  },
  {
    "question": "Which prophet was given the Torah?",
    "questionUrdu": "کون سے نبی کو تورات دی گئی؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Isa (AS)", "Dawud (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "داوود (علیہ السلام)"
    ],
    "correctAnswer": "Musa (AS)",
    "correctAnswerUrdu": "موسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Musa (Moses) was given the Torah as guidance for the Children of Israel.",
    "explanationUrdu":
        "نبی موسیٰ (علیہ السلام) کو بنی اسرائیل کے لئے رہنمائی کے طور پر تورات دی گئی۔"
  },
  {
    "question": "What is the meal called when Muslims break their fast?",
    "questionUrdu":
        "مسلمان جب روزہ افطار کرتے ہیں تو اس کھانے کو کیا کہتے ہیں؟",
    "options": ["Suhur", "Iftar", "Lunch", "Dinner"],
    "optionsUrdu": ["سحور", "افطار", "دوپہر کا کھانا", "رات کا کھانا"],
    "correctAnswer": "Iftar",
    "correctAnswerUrdu": "افطار",
    "explanation":
        "Iftar is the evening meal when Muslims break their fast during Ramadan at sunset.",
    "explanationUrdu":
        "افطار وہ شام کا کھانا ہے جب مسلمان رمضان میں غروب آفتاب کے وقت اپنا روزہ کھولتے ہیں۔"
  },
  {
    "question": "How many Rakats are in Maghrib prayer?",
    "questionUrdu": "مغرب کی نماز میں کتنی رکعتیں ہیں؟",
    "options": ["2", "3", "4", "5"],
    "optionsUrdu": ["2", "3", "4", "5"],
    "correctAnswer": "3",
    "correctAnswerUrdu": "3",
    "explanation":
        "Maghrib prayer consists of 3 Rakats and is performed just after sunset.",
    "explanationUrdu":
        "مغرب کی نماز 3 رکعتوں پر مشتمل ہے اور غروب آفتاب کے فوراً بعد ادا کی جاتی ہے۔"
  },
  {
    "question": "Which angel is responsible for bringing rain?",
    "questionUrdu": "بارش لانے کے لئے کون سا فرشتہ ذمہ دار ہے؟",
    "options": ["Jibreel (AS)", "Mikail (AS)", "Israfil (AS)", "Azrail (AS)"],
    "optionsUrdu": [
      "جبریل (علیہ السلام)",
      "میکائیل (علیہ السلام)",
      "اسرافیل (علیہ السلام)",
      "عزرائیل (علیہ السلام)"
    ],
    "correctAnswer": "Mikail (AS)",
    "correctAnswerUrdu": "میکائیل (علیہ السلام)",
    "explanation":
        "Angel Mikail (Michael) is responsible for natural phenomena like rain and wind.",
    "explanationUrdu":
        "فرشتہ میکائیل (علیہ السلام) بارش اور ہوا جیسے قدرتی مظاہر کے لئے ذمہ دار ہے۔"
  },
  {
    "question": "What is the Arabic word for hell?",
    "questionUrdu": "جہنم کے لئے عربی لفظ کیا ہے؟",
    "options": ["Jannah", "Jahannam", "Barzakh", "Sirat"],
    "optionsUrdu": ["جنت", "جہنم", "برزخ", "صراط"],
    "correctAnswer": "Jahannam",
    "correctAnswerUrdu": "جہنم",
    "explanation":
        "Jahannam is the Arabic word for hell, the punishment for those who reject Allah.",
    "explanationUrdu":
        "جہنم جہنم کے لئے عربی لفظ ہے، جو ان لوگوں کے لئے سزا ہے جو اللہ کو مسترد کرتے ہیں۔"
  },
  {
    "question": "Which prophet interpreted dreams?",
    "questionUrdu": "کون سے نبی نے خوابوں کی تعبیر کی؟",
    "options": ["Yusuf (AS)", "Yaqub (AS)", "Ishaq (AS)", "Ismail (AS)"],
    "optionsUrdu": [
      "یوسف (علیہ السلام)",
      "یعقوب (علیہ السلام)",
      "اسحاق (علیہ السلام)",
      "اسماعیل (علیہ السلام)"
    ],
    "correctAnswer": "Yusuf (AS)",
    "correctAnswerUrdu": "یوسف (علیہ السلام)",
    "explanation":
        "Prophet Yusuf (Joseph) was blessed with the ability to interpret dreams accurately.",
    "explanationUrdu":
        "نبی یوسف (علیہ السلام) کو خوابوں کی درست تعبیر کرنے کی صلاحیت سے نوازا گیا تھا۔"
  },
  {
    "question": "What does \"Allahu Akbar\" mean?",
    "questionUrdu": "\"اللہ اکبر\" کا کیا مطلب ہے؟",
    "options": [
      "Allah is merciful",
      "Allah is great",
      "Allah is one",
      "Allah is forgiving"
    ],
    "optionsUrdu": [
      "اللہ رحیم ہے",
      "اللہ عظیم ہے",
      "اللہ ایک ہے",
      "اللہ معاف کرنے والا ہے"
    ],
    "correctAnswer": "Allah is great",
    "correctAnswerUrdu": "اللہ عظیم ہے",
    "explanation":
        "Allahu Akbar means \"Allah is great\" and is said during prayer and other occasions.",
    "explanationUrdu":
        "اللہ اکبر کا مطلب ہے \"اللہ عظیم ہے\" اور یہ نماز اور دیگر مواقع پر کہا جاتا ہے۔"
  },
  {
    "question": "Which month comes after Ramadan?",
    "questionUrdu": "رمضان کے بعد کون سا مہینہ آتا ہے؟",
    "options": ["Muharram", "Safar", "Shawwal", "Dhul Qadah"],
    "optionsUrdu": ["محرم", "صفر", "شوال", "ذوالقعدہ"],
    "correctAnswer": "Shawwal",
    "correctAnswerUrdu": "شوال",
    "explanation":
        "Shawwal is the month that follows Ramadan, beginning with Eid al-Fitr.",
    "explanationUrdu":
        "شوال وہ مہینہ ہے جو رمضان کے بعد آتا ہے، جو عید الفطر سے شروع ہوتا ہے۔"
  },
  {
    "question": "How many wives did Prophet Muhammad (PBUH) have?",
    "questionUrdu": "نبی محمد صلی اللہ علیہ وسلم کی کتنی بیویاں تھیں؟",
    "options": ["9", "11", "13", "15"],
    "optionsUrdu": ["9", "11", "13", "15"],
    "correctAnswer": "11",
    "correctAnswerUrdu": "11",
    "explanation":
        "Prophet Muhammad (PBUH) had eleven wives, all marriages serving social and political purposes.",
    "explanationUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کی گیارہ بیویاں تھیں، تمام شادیاں سماجی اور سیاسی مقاصد کے لئے تھیں۔"
  },
  {
    "question": "What is the longest Surah in the Quran?",
    "questionUrdu": "قرآن کی سب سے لمبی سورہ کون سی ہے؟",
    "options": ["Al-Fatiha", "Al-Baqarah", "Al-Imran", "An-Nisa"],
    "optionsUrdu": ["الفاتحہ", "البقرہ", "آل عمران", "النساء"],
    "correctAnswer": "Al-Baqarah",
    "correctAnswerUrdu": "البقرہ",
    "explanation":
        "Surah Al-Baqarah (The Cow) is the longest chapter in the Quran with 286 verses.",
    "explanationUrdu":
        "سورہ البقرہ (گائے) قرآن کا سب سے لمبا باب ہے جس میں 286 آیات ہیں۔"
  },
  {
    "question": "Which prophet split the sea?",
    "questionUrdu": "کون سے نبی نے سمندر کو تقسیم کیا؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Nuh (AS)", "Isa (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "نوح (علیہ السلام)",
      "عیسیٰ (علیہ السلام)"
    ],
    "correctAnswer": "Musa (AS)",
    "correctAnswerUrdu": "موسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Musa (Moses) split the Red Sea with Allah's miracle to save the Israelites from Pharaoh.",
    "explanationUrdu":
        "نبی موسیٰ (علیہ السلام) نے اللہ کے معجزے سے بحیرہ احمر کو تقسیم کیا تاکہ بنی اسرائیل کو فرعون سے بچایا جا سکے۔"
  },
  {
    "question": "What is the Islamic New Year called?",
    "questionUrdu": "اسلامی نیا سال کیا کہلاتا ہے؟",
    "options": ["Eid al-Fitr", "Eid al-Adha", "Muharram", "Mawlid"],
    "optionsUrdu": ["عید الفطر", "عید الاضحی", "محرم", "مولد"],
    "correctAnswer": "Muharram",
    "correctAnswerUrdu": "محرم",
    "explanation":
        "The Islamic New Year begins with the month of Muharram, the first month of the Islamic calendar.",
    "explanationUrdu":
        "اسلامی نیا سال محرم کے مہینے سے شروع ہوتا ہے، جو اسلامی کیلنڈر کا پہلا مہینہ ہے۔"
  },
  {
    "question": "Which companion was known as \"The Truthful\"?",
    "questionUrdu": "کون سا صحابی \"صادق\" کے نام سے مشہور تھا؟",
    "options": ["Abu Bakr (RA)", "Umar (RA)", "Uthman (RA)", "Ali (RA)"],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "عمر (رضی اللہ عنہ)",
      "عثمان (رضی اللہ عنہ)",
      "علی (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Abu Bakr (RA)",
    "correctAnswerUrdu": "ابو بکر (رضی اللہ عنہ)",
    "explanation":
        "Abu Bakr (RA) was called \"As-Siddiq\" meaning \"The Truthful\" for his honesty and faith.",
    "explanationUrdu":
        "ابو بکر (رضی اللہ عنہ) کو \"الصدیق\" کہا جاتا تھا جس کا مطلب ہے \"صادق\" ان کی ایمانداری اور ایمان کی وجہ سے۔"
  },
  {
    "question": "What is the bridge over hell called?",
    "questionUrdu": "جہنم کے اوپر پل کو کیا کہتے ہیں؟",
    "options": ["Sirat", "Mizan", "Hawd", "Barzakh"],
    "optionsUrdu": ["صراط", "میزان", "حوض", "برزخ"],
    "correctAnswer": "Sirat",
    "correctAnswerUrdu": "صراط",
    "explanation":
        "As-Sirat is the bridge over hell that all people must cross on the Day of Judgment.",
    "explanationUrdu":
        "صراط وہ پل ہے جو جہنم کے اوپر ہے اور قیامت کے دن سب کو اس سے گزرنا ہوگا۔"
  },
  {
    "question": "Which prophet was raised to heaven alive?",
    "questionUrdu": "کون سا نبی زندہ آسمان پر اٹھایا گیا؟",
    "options": ["Isa (AS)", "Idris (AS)", "Both Isa and Idris", "Ibrahim (AS)"],
    "optionsUrdu": [
      "عیسیٰ (علیہ السلام)",
      "ادریس (علیہ السلام)",
      "عیسیٰ اور ادریس دونوں",
      "ابراہیم (علیہ السلام)"
    ],
    "correctAnswer": "Both Isa and Idris",
    "correctAnswerUrdu": "عیسیٰ اور ادریس دونوں",
    "explanation":
        "Both Prophet Isa (Jesus) and Prophet Idris (Enoch) were raised to heaven alive by Allah.",
    "explanationUrdu":
        "نبی عیسیٰ (عیسیٰ) اور نبی ادریس (علیہ السلام) دونوں کو اللہ نے زندہ آسمان پر اٹھایا۔"
  },
  {
    "question": "What is the Arabic term for charity given during Ramadan?",
    "questionUrdu": "رمضان میں دی جانے والی صدقہ کے لئے عربی اصطلاح کیا ہے؟",
    "options": ["Zakat", "Sadaqah", "Zakat al-Fitr", "Khums"],
    "optionsUrdu": ["زکوٰۃ", "صدقہ", "زکوٰۃ الفطر", "خمس"],
    "correctAnswer": "Zakat al-Fitr",
    "correctAnswerUrdu": "زکوٰۃ الفطر",
    "explanation":
        "Zakat al-Fitr is the special charity given at the end of Ramadan before Eid prayer.",
    "explanationUrdu":
        "زکوٰۃ الفطر وہ خاص صدقہ ہے جو رمضان کے آخر میں عید کی نماز سے پہلے دیا جاتا ہے۔"
  },
  {
    "question": "How many levels does Jannah have?",
    "questionUrdu": "جنت کے کتنے درجے ہیں؟",
    "options": ["7", "8", "100", "1000"],
    "optionsUrdu": ["7", "8", "100", "1000"],
    "correctAnswer": "100",
    "correctAnswerUrdu": "100",
    "explanation":
        "Jannah has 100 levels, with the highest being Firdaws, reserved for the most righteous.",
    "explanationUrdu":
        "جنت کے 100 درجے ہیں، جن میں سب سے بلند فردوس ہے، جو سب سے زیادہ نیک لوگوں کے لئے مختص ہے۔"
  },
  {
    "question": "Which prophet was known for his beauty?",
    "questionUrdu": "کون سا نبی اپنی خوبصورتی کے لئے مشہور تھا؟",
    "options": ["Yusuf (AS)", "Sulaiman (AS)", "Dawud (AS)", "Harun (AS)"],
    "optionsUrdu": [
      "یوسف (علیہ السلام)",
      "سلیمان (علیہ السلام)",
      "داوود (علیہ السلام)",
      "ہارون (علیہ السلام)"
    ],
    "correctAnswer": "Yusuf (AS)",
    "correctAnswerUrdu": "یوسف (علیہ السلام)",
    "explanation":
        "Prophet Yusuf (Joseph) was blessed with extraordinary physical beauty that amazed people.",
    "explanationUrdu":
        "نبی یوسف (علیہ السلام) کو غیر معمولی جسمانی خوبصورتی سے نوازا گیا تھا جو لوگوں کو حیران کر دیتی تھی۔"
  },
  {
    "question": "What is the name of Prophet Muhammad's (PBUH) father?",
    "questionUrdu": "نبی محمد صلی اللہ علیہ وسلم کے والد کا نام کیا تھا؟",
    "options": ["Abdul Muttalib", "Abdullah", "Abu Talib", "Abbas"],
    "optionsUrdu": ["عبدالمطلب", "عبداللہ", "ابو طالب", "عباس"],
    "correctAnswer": "Abdullah",
    "correctAnswerUrdu": "عبداللہ",
    "explanation":
        "Abdullah ibn Abdul Muttalib was the father of Prophet Muhammad (PBUH), who died before his birth.",
    "explanationUrdu":
        "عبداللہ بن عبدالمطلب نبی محمد صلی اللہ علیہ وسلم کے والد تھے، جو ان کی پیدائش سے پہلے وفات پا گئے۔"
  },
  {
    "question": "Which prayer has no Sunnah before or after it?",
    "questionUrdu": "کون سی نماز کے پہلے یا بعد میں کوئی سنت نہیں ہے؟",
    "options": ["Fajr", "Dhuhr", "Asr", "Maghrib"],
    "optionsUrdu": ["فجر", "ظہر", "عصر", "مغرب"],
    "correctAnswer": "Asr",
    "correctAnswerUrdu": "عصر",
    "explanation":
        "Asr prayer has no regular Sunnah prayers before or after the obligatory 4 Rakats.",
    "explanationUrdu":
        "عصر کی نماز کے واجب 4 رکعتوں سے پہلے یا بعد میں کوئی باقاعدہ سنت نمازیں نہیں ہیں۔"
  },
  {
    "question": "What is the name of the she-camel of Prophet Salih (AS)?",
    "questionUrdu": "نبی صالح (علیہ السلام) کی اونٹنی کا نام کیا تھا؟",
    "options": ["Naqah", "Buraq", "Qaswa", "No specific name given"],
    "optionsUrdu": ["ناقہ", "براق", "قصواء", "کوئی مخصوص نام نہیں دیا گیا"],
    "correctAnswer": "Naqah",
    "correctAnswerUrdu": "ناقہ",
    "explanation":
        "The she-camel of Prophet Salih was called \"Naqah\" and was a miraculous sign from Allah.",
    "explanationUrdu":
        "نبی صالح کی اونٹنی کو \"ناقہ\" کہا جاتا تھا اور یہ اللہ کی طرف سے ایک معجزاتی نشانی تھی۔"
  },
  {
    "question": "Which prophet was a carpenter?",
    "questionUrdu": "کون سا نبی بڑھئی تھا؟",
    "options": ["Isa (AS)", "Nuh (AS)", "Zakariya (AS)", "Yaqub (AS)"],
    "optionsUrdu": [
      "عیسیٰ (علیہ السلام)",
      "نوح (علیہ السلام)",
      "زکریا (علیہ السلام)",
      "یعقوب (علیہ السلام)"
    ],
    "correctAnswer": "Zakariya (AS)",
    "correctAnswerUrdu": "زکریا (علیہ السلام)",
    "explanation":
        "Prophet Zakariya (Zechariah) worked as a carpenter and was the guardian of Maryam (AS).",
    "explanationUrdu":
        "نبی زکریا (علیہ السلام) بڑھئی کا کام کرتے تھے اور مریم (علیہ السلام) کے سرپرست تھے۔"
  },
  {
    "question": "What does \"Astaghfirullah\" mean?",
    "questionUrdu": "\"استغفراللہ\" کا کیا مطلب ہے؟",
    "options": [
      "Praise Allah",
      "I seek forgiveness from Allah",
      "Allah is great",
      "Thank Allah"
    ],
    "optionsUrdu": [
      "اللہ کی حمد کرو",
      "میں اللہ سے مغفرت مانگتا ہوں",
      "اللہ عظیم ہے",
      "اللہ کا شکر کرو"
    ],
    "correctAnswer": "I seek forgiveness from Allah",
    "correctAnswerUrdu": "میں اللہ سے مغفرت مانگتا ہوں",
    "explanation":
        "Astaghfirullah means \"I seek forgiveness from Allah\" and is said when asking for Allah's forgiveness.",
    "explanationUrdu":
        "استغفراللہ کا مطلب ہے \"میں اللہ سے مغفرت مانگتا ہوں\" اور یہ اللہ سے معافی مانگتے وقت کہا جاتا ہے۔"
  },
  {
    "question": "How many years did Prophet Nuh (AS) preach to his people?",
    "questionUrdu": "نبی نوح (علیہ السلام) نے اپنی قوم کو کتنے سال تبلیغ کی؟",
    "options": ["500 years", "750 years", "950 years", "1000 years"],
    "optionsUrdu": ["500 سال", "750 سال", "950 سال", "1000 سال"],
    "correctAnswer": "950 years",
    "correctAnswerUrdu": "950 سال",
    "explanation":
        "Prophet Nuh (Noah) preached to his people for 950 years before the great flood.",
    "explanationUrdu":
        "نبی نوح (علیہ السلام) نے عظیم طوفان سے پہلے اپنی قوم کو 950 سال تک تبلیغ کی۔"
  },
  {
    "question": "Which angel is responsible for taking souls?",
    "questionUrdu": "جانوں کو لینے کے لئے کون سا فرشتہ ذمہ دار ہے؟",
    "options": ["Jibreel (AS)", "Mikail (AS)", "Israfil (AS)", "Azrail (AS)"],
    "optionsUrdu": [
      "جبریل (علیہ السلام)",
      "میکائیل (علیہ السلام)",
      "اسرافیل (علیہ السلام)",
      "عزرائیل (علیہ السلام)"
    ],
    "correctAnswer": "Azrail (AS)",
    "correctAnswerUrdu": "عزرائیل (علیہ السلام)",
    "explanation":
        "Angel Azrail (Angel of Death) is responsible for taking souls when their time comes.",
    "explanationUrdu":
        "فرشتہ عزرائیل (موت کا فرشتہ) اس وقت جان لینے کے لئے ذمہ دار ہے جب ان کا وقت آتا ہے۔"
  },
  {
    "question": "How many years did it take for the Quran to be revealed?",
    "questionUrdu": "قرآن کا نزول کتنے سالوں میں مکمل ہوا؟",
    "options": ["20 years", "23 years", "25 years", "30 years"],
    "optionsUrdu": ["20 سال", "23 سال", "25 سال", "30 سال"],
    "correctAnswer": "23 years",
    "correctAnswerUrdu": "23 سال",
    "explanation":
        "The Quran was revealed over a period of 23 years during the prophethood of Muhammad (PBUH).",
    "explanationUrdu":
        "قرآن 23 سال کی مدت میں محمد صلی اللہ علیہ وسلم کی نبوت کے دوران نازل ہوا۔"
  },
  {
    "question": "What is the name of Prophet Muhammad's (PBUH) mother?",
    "questionUrdu": "نبی محمد صلی اللہ علیہ وسلم کی والدہ کا نام کیا تھا؟",
    "options": ["Aminah", "Fatimah", "Khadijah", "Halimah"],
    "optionsUrdu": ["آمنہ", "فاطمہ", "خدیجہ", "حلیمہ"],
    "correctAnswer": "Aminah",
    "correctAnswerUrdu": "آمنہ",
    "explanation":
        "Aminah bint Wahb was the mother of Prophet Muhammad (PBUH).",
    "explanationUrdu": "آمنہ بنت وہب نبی محمد صلی اللہ علیہ وسلم کی والدہ تھیں۔"
  },
  {
    "question": "Which Surah mentions the story of the elephant?",
    "questionUrdu": "کون سی سورہ میں ہاتھی کی کہانی کا ذکر ہے؟",
    "options": ["Al-Fil", "Al-Quraish", "Al-Masad", "Al-Kafirun"],
    "optionsUrdu": ["الفیل", "القریش", "المسد", "الکافرون"],
    "correctAnswer": "Al-Fil",
    "correctAnswerUrdu": "الفیل",
    "explanation":
        "Surah Al-Fil tells the story of Abraha's army with elephants that tried to destroy the Kaaba.",
    "explanationUrdu":
        "سورہ الفیل میں ابراہہ کی فوج کی کہانی ہے جس نے ہاتھیوں کے ساتھ کعبہ کو تباہ کرنے کی کوشش کی۔"
  },
  {
    "question":
        "What is the term for the pilgrimage that can be performed any time?",
    "questionUrdu":
        "اس حج کو کیا کہتے ہیں جو سال کے کسی بھی وقت کیا جا سکتا ہے؟",
    "options": ["Hajj", "Umrah", "Ziyarah", "Tawaf"],
    "optionsUrdu": ["حج", "عمرہ", "زیارت", "طواف"],
    "correctAnswer": "Umrah",
    "correctAnswerUrdu": "عمرہ",
    "explanation":
        "Umrah is the minor pilgrimage that can be performed at any time of the year.",
    "explanationUrdu": "عمرہ چھوٹا حج ہے جو سال کے کسی بھی وقت کیا جا سکتا ہے۔"
  },
  {
    "question": "How many Rakats are in Isha prayer?",
    "questionUrdu": "عشاء کی نماز میں کتنی رکعتیں ہیں؟",
    "options": ["3", "4", "5", "6"],
    "optionsUrdu": ["3", "4", "5", "6"],
    "correctAnswer": "4",
    "correctAnswerUrdu": "4",
    "explanation":
        "Isha prayer consists of 4 Rakats and is the last prayer of the day.",
    "explanationUrdu":
        "عشاء کی نماز 4 رکعتوں پر مشتمل ہے اور یہ دن کی آخری نماز ہے۔"
  },
  {
    "question": "Which prophet was swallowed by the earth?",
    "questionUrdu": "کون سا نبی زمین میں دھنس گیا تھا؟",
    "options": ["Qarun", "Firaun", "Haman", "None - this was not a prophet"],
    "optionsUrdu": ["قارون", "فرعون", "ہامان", "کوئی نہیں - یہ نبی نہیں تھا"],
    "correctAnswer": "None - this was not a prophet",
    "correctAnswerUrdu": "کوئی نہیں - یہ نبی نہیں تھا",
    "explanation":
        "Qarun was swallowed by the earth, but he was not a prophet. He was a wealthy man who became arrogant.",
    "explanationUrdu":
        "قارون زمین میں دھنس گیا تھا، لیکن وہ نبی نہیں تھا۔ وہ ایک دولت مند شخص تھا جو مغرور ہو گیا تھا۔"
  },
  {
    "question":
        "What is the name of the mountain where Prophet Muhammad (PBUH) received his first revelation?",
    "questionUrdu":
        "اس پہاڑ کا نام کیا ہے جہاں نبی محمد صلی اللہ علیہ وسلم کو پہلی وحی موصول ہوئی؟",
    "options": ["Mount Sinai", "Mount Uhud", "Mount Hira", "Mount Arafat"],
    "optionsUrdu": ["جبل سینا", "جبل احد", "جبل حرا", "جبل عرفات"],
    "correctAnswer": "Mount Hira",
    "correctAnswerUrdu": "جبل حرا",
    "explanation":
        "Prophet Muhammad (PBUH) received his first revelation in the cave of Hira on Mount Hira (Jabal an-Nur).",
    "explanationUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کو جبل حرا (جبل النور) پر غار حرا میں پہلی وحی موصول ہوئی۔"
  },
  {
    "question": "Which prophet was given wisdom as a young boy?",
    "questionUrdu": "کون سا نبی بچپن میں حکمت سے نوازا گیا تھا؟",
    "options": ["Sulaiman (AS)", "Yahya (AS)", "Isa (AS)", "Yusuf (AS)"],
    "optionsUrdu": [
      "سلیمان (علیہ السلام)",
      "یہیٰ (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "یوسف (علیہ السلام)"
    ],
    "correctAnswer": "Yahya (AS)",
    "correctAnswerUrdu": "یہیٰ (علیہ السلام)",
    "explanation":
        "Prophet Yahya (John the Baptist) was given wisdom and prophethood as a young child.",
    "explanationUrdu":
        "نبی یحییٰ (علیہ السلام) کو بچپن میں حکمت اور نبوت عطا کی گئی تھی۔"
  },
  {
    "question": "What is the response to \"Assalamu Alaikum\"?",
    "questionUrdu": "\"السلام علیکم\" کا جواب کیا ہے؟",
    "options": [
      "Alaikum Assalam",
      "Wa alaikum assalam",
      "Assalamu alaikum",
      "Barakallahu feek"
    ],
    "optionsUrdu": [
      "علیکم السلام",
      "وعلیکم السلام",
      "السلام علیکم",
      "برک اللہ فیک"
    ],
    "correctAnswer": "Wa alaikum assalam",
    "correctAnswerUrdu": "وعلیکم السلام",
    "explanation":
        "The proper response to \"Assalamu Alaikum\" is \"Wa alaikum assalam\" meaning \"And peace be upon you too\".",
    "explanationUrdu":
        "\"السلام علیکم\" کا مناسب جواب \"وعلیکم السلام\" ہے جس کا مطلب ہے \"اور تم پر بھی سلامتی ہو\"۔"
  },
  {
    "question": "Which companion was known as \"The Sword of Allah\"?",
    "questionUrdu": "کون سا صحابی \"اللہ کی تلوار\" کے نام سے مشہور تھا؟",
    "options": [
      "Ali (RA)",
      "Khalid ibn Walid (RA)",
      "Hamza (RA)",
      "Sa'd ibn Abi Waqqas (RA)"
    ],
    "optionsUrdu": [
      "علی (رضی اللہ عنہ)",
      "خالد بن ولید (رضی اللہ عنہ)",
      "حمزہ (رضی اللہ عنہ)",
      "سعد بن ابی وقاص (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Khalid ibn Walid (RA)",
    "correctAnswerUrdu": "خالد بن ولید (رضی اللہ عنہ)",
    "explanation":
        "Khalid ibn Walid (RA) was called \"Saif Allah al-Maslul\" (The Drawn Sword of Allah) for his military prowess.",
    "explanationUrdu":
        "خالد بن ولید (رضی اللہ عنہ) کو ان کی فوجی بہادری کی وجہ سے \"سیف اللہ المسلول\" (اللہ کی کھینچی ہوئی تلوار) کہا جاتا تھا۔"
  },
  {
    "question": "What is the Arabic term for the Day of Resurrection?",
    "questionUrdu": "قیامت کے دن کے لئے عربی اصطلاح کیا ہے؟",
    "options": [
      "Yawm al-Qiyamah",
      "Yawm al-Ba'th",
      "Yawm al-Din",
      "All of the above"
    ],
    "optionsUrdu": ["یوم القیامہ", "یوم البعث", "یوم الدین", "مذکورہ بالا سب"],
    "correctAnswer": "All of the above",
    "correctAnswerUrdu": "مذکورہ بالا سب",
    "explanation":
        "The Day of Judgment is known by various names including Yawm al-Qiyamah, Yawm al-Ba'th, and Yawm al-Din.",
    "explanationUrdu":
        "قیامت کا دن مختلف ناموں سے جانا جاتا ہے جن میں یوم القیامہ، یوم البعث، اور یوم الدین شامل ہیں۔"
  },
  {
    "question": "Which prophet was thrown into a well by his brothers?",
    "questionUrdu": "کون سا نبی اپنے بھائیوں نے کنویں میں پھینک دیا تھا؟",
    "options": ["Yusuf (AS)", "Yaqub (AS)", "Ishaq (AS)", "Ismail (AS)"],
    "optionsUrdu": [
      "یوسف (علیہ السلام)",
      "یعقوب (علیہ السلام)",
      "اسحاق (علیہ السلام)",
      "اسماعیل (علیہ السلام)"
    ],
    "correctAnswer": "Yusuf (AS)",
    "correctAnswerUrdu": "یوسف (علیہ السلام)",
    "explanation":
        "Prophet Yusuf (Joseph) was thrown into a well by his jealous brothers when he was young.",
    "explanationUrdu":
        "نبی یوسف (علیہ السلام) کو ان کے حسد کرنے والے بھائیوں نے بچپن میں کنویں میں پھینک دیا تھا۔"
  },
  {
    "question": "What is the name of the gate of heaven?",
    "questionUrdu": "جنت کے دروازے کا نام کیا ہے؟",
    "options": [
      "Baab as-Sabr",
      "Baab ar-Rayyan",
      "Baab as-Salah",
      "All are gates of heaven"
    ],
    "optionsUrdu": [
      "باب الصبر",
      "باب الریان",
      "باب الصلاة",
      "سب جنت کے دروازے ہیں"
    ],
    "correctAnswer": "All are gates of heaven",
    "correctAnswerUrdu": "سب جنت کے دروازے ہیں",
    "explanation":
        "Heaven has multiple gates including Baab ar-Rayyan (for those who fast), Baab as-Salah (for prayer), etc.",
    "explanationUrdu":
        "جنت کے متعدد دروازے ہیں جن میں باب الریان (روزہ رکھنے والوں کے لئے)، باب الصلاة (نماز کے لئے) وغیرہ شامل ہیں۔"
  },
  {
    "question": "Which prophet was known for his strength?",
    "questionUrdu": "کون سا نبی اپنی طاقت کے لئے مشہور تھا؟",
    "options": ["Sulaiman (AS)", "Dawud (AS)", "Musa (AS)", "Ibrahim (AS)"],
    "optionsUrdu": [
      "سلیمان (علیہ السلام)",
      "داوود (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "ابراہیم (علیہ السلام)"
    ],
    "correctAnswer": "Musa (AS)",
    "correctAnswerUrdu": "موسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Musa (Moses) was known for his physical strength, demonstrated when he helped the daughters of Shu'aib.",
    "explanationUrdu":
        "نبی موسیٰ (علیہ السلام) اپنی جسمانی طاقت کے لئے مشہور تھے، جو انہوں نے شعیب کی بیٹیوں کی مدد کرتے وقت ظاہر کی۔"
  },
  {
    "question": "What is the term for the middle prayer?",
    "questionUrdu": "درمیانی نماز کو کیا کہتے ہیں؟",
    "options": ["Fajr", "Dhuhr", "Asr", "Maghrib"],
    "optionsUrdu": ["فجر", "ظہر", "عصر", "مغرب"],
    "correctAnswer": "Asr",
    "correctAnswerUrdu": "عصر",
    "explanation":
        "Asr prayer is referred to as \"Salat al-Wusta\" (the middle prayer) in the Quran.",
    "explanationUrdu":
        "عصر کی نماز کو قرآن میں \"صلاة الوسطیٰ\" (درمیانی نماز) کہا جاتا ہے۔"
  },
  {
    "question":
        "Which prophet was given a kingdom that no one after him would have?",
    "questionUrdu":
        "کون سا نبی ایسی سلطنت دیا گیا تھا جو اس کے بعد کسی کو نہیں ملے گی؟",
    "options": [
      "Dawud (AS)",
      "Sulaiman (AS)",
      "Yusuf (AS)",
      "Dhul-Qarnayn (AS)"
    ],
    "optionsUrdu": [
      "داوود (علیہ السلام)",
      "سلیمان (علیہ السلام)",
      "یوسف (علیہ السلام)",
      "ذوالقرنین (علیہ السلام)"
    ],
    "correctAnswer": "Sulaiman (AS)",
    "correctAnswerUrdu": "سلیمان (علیہ السلام)",
    "explanation":
        "Prophet Sulaiman (Solomon) was given a unique kingdom with power over humans, jinn, and animals.",
    "explanationUrdu":
        "نبی سلیمان (علیہ السلام) کو ایک منفرد سلطنت دی گئی تھی جس میں انسانوں، جنوں اور جانوروں پر اختیار تھا۔"
  },
  {
    "question":
        "What is the name of the first mosque built by Prophet Muhammad (PBUH)?",
    "questionUrdu":
        "نبی محمد صلی اللہ علیہ وسلم نے سب سے پہلے کون سی مسجد بنائی؟",
    "options": [
      "Masjid al-Haram",
      "Masjid an-Nabawi",
      "Masjid Quba",
      "Masjid al-Aqsa"
    ],
    "optionsUrdu": ["مسجد الحرام", "مسجد نبوی", "مسجد قبا", "مسجد اقصیٰ"],
    "correctAnswer": "Masjid Quba",
    "correctAnswerUrdu": "مسجد قبا",
    "explanation":
        "Masjid Quba in Medina was the first mosque built by Prophet Muhammad (PBUH) upon arriving from Mecca.",
    "explanationUrdu":
        "مدینہ میں مسجد قبا وہ پہلی مسجد تھی جو نبی محمد صلی اللہ علیہ وسلم نے مکہ سے آنے پر بنائی۔"
  },
  {
    "question":
        "How many times is Prophet Muhammad (PBUH) mentioned by name in the Quran?",
    "questionUrdu":
        "قرآن میں نبی محمد صلی اللہ علیہ وسلم کا نام کتنی بار ذکر ہوا ہے؟",
    "options": ["3", "4", "5", "6"],
    "optionsUrdu": ["3", "4", "5", "6"],
    "correctAnswer": "4",
    "correctAnswerUrdu": "4",
    "explanation":
        "Prophet Muhammad (PBUH) is mentioned by name 4 times in the Quran, and once as \"Ahmad\".",
    "explanationUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کا نام قرآن میں 4 بار ذکر ہوا ہے، اور ایک بار \"احمد\" کے طور پر۔"
  },
  {
    "question": "Which prophet was born without a father?",
    "questionUrdu": "کون سا نبی بغیر باپ کے پیدا ہوا؟",
    "options": ["Adam (AS)", "Isa (AS)", "Yahya (AS)", "Ibrahim (AS)"],
    "optionsUrdu": [
      "آدم (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "یحییٰ (علیہ السلام)",
      "ابراہیم (علیہ السلام)"
    ],
    "correctAnswer": "Isa (AS)",
    "correctAnswerUrdu": "عیسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Isa (Jesus) was born to Maryam (Mary) without a father, as a miracle from Allah.",
    "explanationUrdu":
        "نبی عیسیٰ (علیہ السلام) مریم (علیہا السلام) سے بغیر باپ کے پیدا ہوئے، جو اللہ کا معجزہ تھا۔"
  },
  {
    "question": "What is the name of the funeral prayer?",
    "questionUrdu": "جنازے کی نماز کا نام کیا ہے؟",
    "options": [
      "Salat al-Janazah",
      "Salat al-Mayyit",
      "Salat al-Ghaib",
      "All of the above"
    ],
    "optionsUrdu": [
      "صلاة الجنازہ",
      "صلاة المیت",
      "صلاة الغائب",
      "مذکورہ بالا سب"
    ],
    "correctAnswer": "Salat al-Janazah",
    "correctAnswerUrdu": "صلاة الجنازہ",
    "explanation":
        "Salat al-Janazah is the funeral prayer performed for deceased Muslims.",
    "explanationUrdu":
        "صلاة الجنازہ وہ جنازے کی نماز ہے جو فوت شدہ مسلمانوں کے لئے ادا کی جاتی ہے۔"
  },
  {
    "question": "Which battle is known as the \"Day of Criterion\"?",
    "questionUrdu": "کون سی لڑائی \"یوم الفرقان\" کے نام سے جانی جاتی ہے؟",
    "options": [
      "Battle of Uhud",
      "Battle of Badr",
      "Battle of Khandaq",
      "Battle of Hunayn"
    ],
    "optionsUrdu": ["جنگ احد", "جنگ بدر", "جنگ خندق", "جنگ حنین"],
    "correctAnswer": "Battle of Badr",
    "correctAnswerUrdu": "جنگ بدر",
    "explanation":
        "The Battle of Badr is called \"Yawm al-Furqan\" (Day of Criterion) as it clearly distinguished between truth and falsehood.",
    "explanationUrdu":
        "جنگ بدر کو \"یوم الفرقان\" (حق و باطل کے درمیان فیصلے کا دن) کہا جاتا ہے کیونکہ اس نے حق اور باطل کے درمیان واضح فرق کیا۔"
  },
  {
    "question": "What does \"Barakallahu feeki\" mean when said to a female?",
    "questionUrdu": "جب عورت سے کہا جائے تو \"برک اللہ فیکی\" کا کیا مطلب ہے؟",
    "options": [
      "May Allah bless you",
      "Thank you",
      "You're welcome",
      "Peace be upon you"
    ],
    "optionsUrdu": [
      "اللہ تمہیں برکت دے",
      "شکریہ",
      "خوش آمدید",
      "تم پر سلامتی ہو"
    ],
    "correctAnswer": "May Allah bless you",
    "correctAnswerUrdu": "اللہ تمہیں برکت دے",
    "explanation":
        "Barakallahu feeki means \"May Allah bless you\" when speaking to a female.",
    "explanationUrdu":
        "برک اللہ فیکی کا مطلب ہے \"اللہ تمہیں برکت دے\" جب عورت سے بات کی جاتی ہے۔"
  },
  {
    "question": "Which prophet was able to cure the blind and lepers?",
    "questionUrdu": "کون سا نبی اندھوں اور کوڑھیوں کو شفا دیتا تھا؟",
    "options": ["Musa (AS)", "Isa (AS)", "Sulaiman (AS)", "Yahya (AS)"],
    "optionsUrdu": [
      "موسیٰ (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "سلیمان (علیہ السلام)",
      "یحییٰ (علیہ السلام)"
    ],
    "correctAnswer": "Isa (AS)",
    "correctAnswerUrdu": "عیسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Isa (Jesus) was given the miracle to heal the blind, cure lepers, and bring the dead back to life.",
    "explanationUrdu":
        "نبی عیسیٰ (علیہ السلام) کو اندھوں کو شفا دینے، کوڑھیوں کو ٹھیک کرنے اور مردوں کو زندہ کرنے کا معجزہ دیا گیا تھا۔"
  },
  {
    "question": "What is the term for the evening prayer?",
    "questionUrdu": "شام کی نماز کو کیا کہتے ہیں؟",
    "options": ["Asr", "Maghrib", "Isha", "Qiyam"],
    "optionsUrdu": ["عصر", "مغرب", "عشاء", "قیام"],
    "correctAnswer": "Maghrib",
    "correctAnswerUrdu": "مغرب",
    "explanation": "Maghrib is the evening prayer performed just after sunset.",
    "explanationUrdu":
        "مغرب شام کی نماز ہے جو غروب آفتاب کے فوراً بعد ادا کی جاتی ہے۔"
  },
  {
    "question": "Which prophet built the first house of worship for Allah?",
    "questionUrdu": "کون سا نبی اللہ کے لئے عبادت کا پہلا گھر بنایا؟",
    "options": ["Adam (AS)", "Ibrahim (AS)", "Nuh (AS)", "Idris (AS)"],
    "optionsUrdu": [
      "آدم (علیہ السلام)",
      "ابراہیم (علیہ السلام)",
      "نوح (علیہ السلام)",
      "ادریس (علیہ السلام)"
    ],
    "correctAnswer": "Ibrahim (AS)",
    "correctAnswerUrdu": "ابراہیم (علیہ السلام)",
    "explanation":
        "Prophet Ibrahim (Abraham) and his son Ismail built the Kaaba, the first house of worship for Allah.",
    "explanationUrdu":
        "نبی ابراہیم (علیہ السلام) اور ان کے بیٹے اسماعیل نے کعبہ بنایا، جو اللہ کے لئے عبادت کا پہلا گھر تھا۔"
  },
  {
    "question":
        "What is the name of the scale that will weigh deeds on Judgment Day?",
    "questionUrdu": "قیامت کے دن اعمال تولنے والی ترازو کا نام کیا ہے؟",
    "options": ["Sirat", "Mizan", "Hawd", "Lawh"],
    "optionsUrdu": ["صراط", "میزان", "حوض", "لوح"],
    "correctAnswer": "Mizan",
    "correctAnswerUrdu": "میزان",
    "explanation":
        "Al-Mizan is the divine scale that will weigh the good and bad deeds of people on the Day of Judgment.",
    "explanationUrdu":
        "المیزان وہ الہی ترازو ہے جو قیامت کے دن لوگوں کے اچھے اور برے اعمال کو تولے گی۔"
  },
  {
    "question": "Which companion was the first to embrace Islam among men?",
    "questionUrdu": "مردوں میں سب سے پہلے کون سا صحابی نے اسلام قبول کیا؟",
    "options": ["Abu Bakr (RA)", "Umar (RA)", "Uthman (RA)", "Ali (RA)"],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "عمر (رضی اللہ عنہ)",
      "عثمان (رضی اللہ عنہ)",
      "علی (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Abu Bakr (RA)",
    "correctAnswerUrdu": "ابو بکر (رضی اللہ عنہ)",
    "explanation":
        "Abu Bakr (RA) was the first adult man to accept Islam and embrace the message of Prophet Muhammad (PBUH).",
    "explanationUrdu":
        "ابو بکر (رضی اللہ عنہ) پہلے بالغ مرد تھے جنہوں نے اسلام قبول کیا اور نبی محمد صلی اللہ علیہ وسلم کا پیغام قبول کیا۔"
  },
  {
    "question": "What is the Arabic term for the Prayer Leader?",
    "questionUrdu": "نماز کے پیشوا کے لئے عربی اصطلاح کیا ہے؟",
    "options": ["Imam", "Muezzin", "Khatib", "Qari"],
    "optionsUrdu": ["امام", "مؤذن", "خطیب", "قاری"],
    "correctAnswer": "Imam",
    "correctAnswerUrdu": "امام",
    "explanation":
        "An Imam is the person who leads the congregational prayer and stands in front of the worshippers.",
    "explanationUrdu":
        "امام وہ شخص ہے جو اجتماعی نماز کی امامت کرتا ہے اور نمازیوں کے سامنے کھڑا ہوتا ہے۔"
  },
  {
    "question": "Which prophet was commanded to sacrifice his son?",
    "questionUrdu": "کون سے نبی کو اپنے بیٹے کی قربانی کا حکم دیا گیا تھا؟",
    "options": ["Ibrahim (AS)", "Yaqub (AS)", "Zakariya (AS)", "Nuh (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "یعقوب (علیہ السلام)",
      "زکریا (علیہ السلام)",
      "نوح (علیہ السلام)"
    ],
    "correctAnswer": "Ibrahim (AS)",
    "correctAnswerUrdu": "ابراہیم (علیہ السلام)",
    "explanation":
        "Prophet Ibrahim (Abraham) was tested by Allah with the command to sacrifice his son Ismail, but Allah provided a ram instead.",
    "explanationUrdu":
        "نبی ابراہیم (علیہ السلام) کو اللہ نے اپنے بیٹے اسماعیل کی قربانی کے حکم سے آزمایا، لیکن اللہ نے اس کی جگہ ایک مینڈھا فراہم کیا۔"
  },
  {
    "question": "What is the name of Prophet Muhammad's (PBUH) grandfather?",
    "questionUrdu": "نبی محمد صلی اللہ علیہ وسلم کے دادا کا نام کیا تھا؟",
    "options": ["Abdullah", "Abdul Muttalib", "Abu Talib", "Hashim"],
    "optionsUrdu": ["عبداللہ", "عبدالمطلب", "ابو طالب", "ہاشم"],
    "correctAnswer": "Abdul Muttalib",
    "correctAnswerUrdu": "عبدالمطلب",
    "explanation":
        "Abdul Muttalib ibn Hashim was the grandfather of Prophet Muhammad (PBUH) and took care of him after his father's death.",
    "explanationUrdu":
        "عبدالمطلب بن ہاشم نبی محمد صلی اللہ علیہ وسلم کے دادا تھے اور انہوں نے ان کے والد کی وفات کے بعد ان کی دیکھ بھال کی۔"
  },
  {
    "question": "Which prophet was given the Gospel (Injeel)?",
    "questionUrdu": "کون سے نبی کو انجیل دی گئی؟",
    "options": ["Musa (AS)", "Isa (AS)", "Dawud (AS)", "Ibrahim (AS)"],
    "optionsUrdu": [
      "موسیٰ (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "داوود (علیہ السلام)",
      "ابراہیم (علیہ السلام)"
    ],
    "correctAnswer": "Isa (AS)",
    "correctAnswerUrdu": "عیسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Isa (Jesus) was given the Injeel (Gospel) as guidance for his followers.",
    "explanationUrdu":
        "نبی عیسیٰ (علیہ السلام) کو ان کے پیروکاروں کے لئے رہنمائی کے طور پر انجیل دی گئی۔"
  },
  {
    "question": "What is the name of the well of Zamzam located near?",
    "questionUrdu": "زمزم کے کنویں کا نام کس کے قریب ہے؟",
    "options": ["Masjid an-Nabawi", "Kaaba", "Mount Arafat", "Mina"],
    "optionsUrdu": ["مسجد نبوی", "کعبہ", "جبل عرفات", "منٰی"],
    "correctAnswer": "Kaaba",
    "correctAnswerUrdu": "کعبہ",
    "explanation":
        "The well of Zamzam is located near the Kaaba in Mecca and provides blessed water to pilgrims.",
    "explanationUrdu":
        "زمزم کا کنواں مکہ میں کعبہ کے قریب واقع ہے اور حاجیوں کو بابرکت پانی فراہم کرتا ہے۔"
  },
  {
    "question": "How many daughters did Prophet Muhammad (PBUH) have?",
    "questionUrdu": "نبی محمد صلی اللہ علیہ وسلم کی کتنی بیٹیاں تھیں؟",
    "options": ["2", "3", "4", "5"],
    "optionsUrdu": ["2", "3", "4", "5"],
    "correctAnswer": "4",
    "correctAnswerUrdu": "4",
    "explanation":
        "Prophet Muhammad (PBUH) had four daughters: Zainab, Ruqayyah, Umm Kulthum, and Fatimah (RA).",
    "explanationUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کی چار بیٹیاں تھیں: زینب، رقیہ، ام کلثوم، اور فاطمہ (رضی اللہ عنہا)۔"
  },
  {
    "question": "Which Surah is recited for protection?",
    "questionUrdu": "حفاظت کے لئے کون سی سورہ پڑھی جاتی ہے؟",
    "options": [
      "Al-Fatiha",
      "Al-Falaq and An-Nas",
      "Al-Ikhlas",
      "Ayat al-Kursi"
    ],
    "optionsUrdu": ["الفاتحہ", "الفلق اور الناس", "الاخلاص", "آیۃ الکرسی"],
    "correctAnswer": "Al-Falaq and An-Nas",
    "correctAnswerUrdu": "الفلق اور الناس",
    "explanation":
        "Surah Al-Falaq and An-Nas are called \"Al-Mu'awwidhatayn\" (the two seeking refuge) and are recited for protection.",
    "explanationUrdu":
        "سورہ الفلق اور الناس کو \"المعوذتین\" کہا جاتا ہے اور یہ حفاظت کے لئے پڑھی جاتی ہیں۔"
  },
  {
    "question": "What is the Islamic term for the community of believers?",
    "questionUrdu": "مومنوں کی جماعت کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Ummah", "Jamaat", "Millah", "Qawm"],
    "optionsUrdu": ["امہ", "جماعت", "ملت", "قوم"],
    "correctAnswer": "Ummah",
    "correctAnswerUrdu": "امہ",
    "explanation":
        "Ummah refers to the global community of Muslims united by their faith in Islam.",
    "explanationUrdu":
        "امہ سے مراد دنیا بھر کے مسلمانوں کی جماعت ہے جو اسلام کے ایمان سے متحد ہیں۔"
  },
  {
    "question": "Which prophet was known as \"Dhul-Nun\"?",
    "questionUrdu": "کون سا نبی \"ذوالنون\" کے نام سے مشہور تھا؟",
    "options": ["Yunus (AS)", "Yusuf (AS)", "Yaqub (AS)", "Yahya (AS)"],
    "optionsUrdu": [
      "یونس (علیہ السلام)",
      "یوسف (علیہ السلام)",
      "یعقوب (علیہ السلام)",
      "یہیٰ (علیہ السلام)"
    ],
    "correctAnswer": "Yunus (AS)",
    "correctAnswerUrdu": "یونس (علیہ السلام)",
    "explanation":
        "Prophet Yunus (Jonah) is called \"Dhul-Nun\" meaning \"the one with the fish/whale\".",
    "explanationUrdu":
        "نبی یونس (علیہ السلام) کو \"ذوالنون\" کہا جاتا ہے جس کا مطلب ہے \"مچھلی/وہیل والا\"۔"
  },
  {
    "question":
        "What is the name of the cave where Prophet Muhammad (PBUH) and Abu Bakr (RA) hid during Hijra?",
    "questionUrdu":
        "ہجرت کے دوران نبی محمد صلی اللہ علیہ وسلم اور ابو بکر (رضی اللہ عنہ) نے کس غار میں پناہ لی؟",
    "options": [
      "Cave of Hira",
      "Cave of Thawr",
      "Cave of Uhud",
      "Cave of Quba"
    ],
    "optionsUrdu": ["غار حرا", "غار ثور", "غار احد", "غار قبا"],
    "correctAnswer": "Cave of Thawr",
    "correctAnswerUrdu": "غار ثور",
    "explanation":
        "During the Hijra, Prophet Muhammad (PBUH) and Abu Bakr (RA) hid in the Cave of Thawr for three days.",
    "explanationUrdu":
        "ہجرت کے دوران، نبی محمد صلی اللہ علیہ وسلم اور ابو بکر (رضی اللہ عنہ) نے تین دن تک غار ثور میں پناہ لی۔"
  },
  {
    "question":
        "How many times should a Muslim perform Hajj in their lifetime?",
    "questionUrdu": "ایک مسلمان کو اپنی زندگی میں کتنی بار حج کرنا چاہئے؟",
    "options": [
      "Once if able",
      "Twice",
      "Three times",
      "As many times as possible"
    ],
    "optionsUrdu": [
      "ایک بار اگر ممکن ہو",
      "دو بار",
      "تین بار",
      "جتنی بار ممکن ہو"
    ],
    "correctAnswer": "Once if able",
    "correctAnswerUrdu": "ایک بار اگر ممکن ہو",
    "explanation":
        "Hajj is obligatory once in a lifetime for Muslims who are physically and financially able to perform it.",
    "explanationUrdu":
        "حج ان مسلمانوں کے لئے زندگی میں ایک بار واجب ہے جو جسمانی اور مالی طور پر اس کی استطاعت رکھتے ہیں۔"
  },
  {
    "question": "Which prophet was thrown into prison in Egypt?",
    "questionUrdu": "کون سا نبی مصر میں قید کیا گیا تھا؟",
    "options": ["Musa (AS)", "Yusuf (AS)", "Harun (AS)", "Lut (AS)"],
    "optionsUrdu": [
      "موسیٰ (علیہ السلام)",
      "یوسف (علیہ السلام)",
      "ہارون (علیہ السلام)",
      "لوط (علیہ السلام)"
    ],
    "correctAnswer": "Yusuf (AS)",
    "correctAnswerUrdu": "یوسف (علیہ السلام)",
    "explanation":
        "Prophet Yusuf (Joseph) was falsely accused and imprisoned in Egypt, where he interpreted dreams.",
    "explanationUrdu":
        "نبی یوسف (علیہ السلام) پر جھوٹا الزام لگایا گیا اور مصر میں قید کیا گیا، جہاں انہوں نے خوابوں کی تعبیر کی۔"
  },
  {
    "question": "What is the Arabic word for Friday?",
    "questionUrdu": "جمعہ کے لئے عربی لفظ کیا ہے؟",
    "options": [
      "Yawm al-Sabt",
      "Yawm al-Ahad",
      "Yawm al-Jumu'ah",
      "Yawm al-Khamis"
    ],
    "optionsUrdu": ["یوم السب", "یوم الاحد", "یوم الجمعہ", "یوم الخمیس"],
    "correctAnswer": "Yawm al-Jumu'ah",
    "correctAnswerUrdu": "یوم الجمعہ",
    "explanation":
        "Friday is called \"Yawm al-Jumu'ah\" in Arabic, meaning the day of congregation for Friday prayers.",
    "explanationUrdu":
        "جمعہ کو عربی میں \"یوم الجمعہ\" کہا جاتا ہے، جس کا مطلب ہے جمعہ کی نماز کے لئے اجتماع کا دن۔"
  },
  {
    "question": "Which companion was known as \"The Lion of Allah\"?",
    "questionUrdu": "کون سا صحابی \"اللہ کا شیر\" کے نام سے مشہور تھا؟",
    "options": ["Abu Bakr (RA)", "Umar (RA)", "Hamza (RA)", "Ali (RA)"],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "عمر (رضی اللہ عنہ)",
      "حمزہ (رضی اللہ عنہ)",
      "علی (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Hamza (RA)",
    "correctAnswerUrdu": "حمزہ (رضی اللہ عنہ)",
    "explanation":
        "Hamza ibn Abdul Muttalib (RA), the uncle of Prophet Muhammad (PBUH), was called \"Asad Allah\" (Lion of Allah).",
    "explanationUrdu":
        "حمزہ بن عبدالمطلب (رضی اللہ عنہ)، نبی محمد صلی اللہ علیہ وسلم کے چچا، کو \"اسد اللہ\" (اللہ کا شیر) کہا جاتا تھا۔"
  },
  {
    "question": "What is the term for the ritual washing before prayer?",
    "questionUrdu": "نماز سے پہلے کی رسمی دھلائی کو کیا کہتے ہیں؟",
    "options": ["Ghusl", "Wudu", "Tayammum", "Istinja"],
    "optionsUrdu": ["غسل", "وضو", "تیمم", "استنجاء"],
    "correctAnswer": "Wudu",
    "correctAnswerUrdu": "وضو",
    "explanation":
        "Wudu is the ritual ablution performed before prayers to achieve spiritual cleanliness.",
    "explanationUrdu":
        "وضو وہ رسمی دھلائی ہے جو روحانی پاکیزگی حاصل کرنے کے لئے نماز سے پہلے کی جاتی ہے۔"
  },
  {
    "question":
        "Which prophet was saved from the fire along with two other believers?",
    "questionUrdu": "کون سا نبی دو دیگر مومنوں کے ساتھ آگ سے بچایا گیا؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Nuh (AS)", "Lut (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "نوح (علیہ السلام)",
      "لوط (علیہ السلام)"
    ],
    "correctAnswer": "Ibrahim (AS)",
    "correctAnswerUrdu": "ابراہیم (علیہ السلام)",
    "explanation":
        "Prophet Ibrahim (AS) was saved from Nimrod's fire, though the \"two other believers\" refers to a different context - Ibrahim was saved alone from the fire.",
    "explanationUrdu":
        "نبی ابراہیم (علیہ السلام) کو نمرود کی آگ سے بچایا گیا، حالانکہ \"دو دیگر مومنوں\" کا حوالہ مختلف سیاق و سباق سے ہے - ابراہیم کو آگ سے اکیلے بچایا گیا تھا۔"
  },
  {
    "question": "What is the name of the Prophet's (PBUH) first wife?",
    "questionUrdu": "نبی صلی اللہ علیہ وسلم کی پہلی بیوی کا نام کیا تھا؟",
    "options": ["Aisha (RA)", "Hafsa (RA)", "Khadijah (RA)", "Sawdah (RA)"],
    "optionsUrdu": [
      "عائشہ (رضی اللہ عنہا)",
      "حفصہ (رضی اللہ عنہا)",
      "خدیجہ (رضی اللہ عنہا)",
      "سودہ (رضی اللہ عنہا)"
    ],
    "correctAnswer": "Khadijah (RA)",
    "correctAnswerUrdu": "خدیجہ (رضی اللہ عنہا)",
    "explanation":
        "Khadijah bint Khuwaylid (RA) was the first wife of Prophet Muhammad (PBUH) and the first person to accept Islam.",
    "explanationUrdu":
        "خدیجہ بنت خویلد (رضی اللہ عنہا) نبی محمد صلی اللہ علیہ وسلم کی پہلی بیوی تھیں اور اسلام قبول کرنے والی پہلی شخصیت تھیں۔"
  },
  {
    "question": "How many verses are in Surah Al-Fatiha?",
    "questionUrdu": "سورہ الفاتحہ میں کتنی آیات ہیں؟",
    "options": ["5", "6", "7", "8"],
    "optionsUrdu": ["5", "6", "7", "8"],
    "correctAnswer": "7",
    "correctAnswerUrdu": "7",
    "explanation":
        "Surah Al-Fatiha has 7 verses and is also known as \"As-Sab'a al-Mathani\" (The Seven Oft-Repeated Verses).",
    "explanationUrdu":
        "سورہ الفاتحہ میں 7 آیات ہیں اور اسے \"السبع المثانی\" (سات بار بار پڑھی جانے والی آیات) بھی کہا جاتا ہے۔"
  },
  {
    "question": "Which prophet was given control over the wind?",
    "questionUrdu": "کون سے نبی کو ہوا پر اختیار دیا گیا تھا؟",
    "options": ["Sulaiman (AS)", "Dawud (AS)", "Isa (AS)", "Musa (AS)"],
    "optionsUrdu": [
      "سلیمان (علیہ السلام)",
      "داوود (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "موسیٰ (علیہ السلام)"
    ],
    "correctAnswer": "Sulaiman (AS)",
    "correctAnswerUrdu": "سلیمان (علیہ السلام)",
    "explanation":
        "Prophet Sulaiman (Solomon) was given control over the wind as part of his miraculous kingdom.",
    "explanationUrdu":
        "نبی سلیمان (علیہ السلام) کو ان کے معجزاتی بادشاہت کے حصے کے طور پر ہوا پر اختیار دیا گیا تھا۔"
  },
  {
    "question": "What is the Arabic term for the annual pilgrimage to Mecca?",
    "questionUrdu": "مکہ کے سالانہ حج کے لئے عربی اصطلاح کیا ہے؟",
    "options": ["Umrah", "Hajj", "Ziyarah", "Safar"],
    "optionsUrdu": ["عمرہ", "حج", "زیارت", "سفر"],
    "correctAnswer": "Hajj",
    "correctAnswerUrdu": "حج",
    "explanation":
        "Hajj is the major pilgrimage to Mecca performed during the month of Dhul Hijjah.",
    "explanationUrdu":
        "حج مکہ کا بڑا حج ہے جو ذوالحجہ کے مہینے میں ادا کیا جاتا ہے۔"
  },
  {
    "question": "Which Surah was revealed entirely in Medina?",
    "questionUrdu": "کون سی سورہ مکمل طور پر مدینہ میں نازل ہوئی؟",
    "options": ["Al-Fatiha", "Al-Baqarah", "Al-Ikhlas", "Al-Falaq"],
    "optionsUrdu": ["الفاتحہ", "البقرہ", "الاخلاص", "الفلق"],
    "correctAnswer": "Al-Baqarah",
    "correctAnswerUrdu": "البقرہ",
    "explanation":
        "Surah Al-Baqarah was the first complete Surah revealed in Medina after the Hijra.",
    "explanationUrdu":
        "سورہ البقرہ ہجرت کے بعد مدینہ میں نازل ہونے والی پہلی مکمل سورہ تھی۔"
  },
  {
    "question": "What is the name of the cloth that covers the Kaaba?",
    "questionUrdu": "کعبہ کو ڈھانپنے والے کپڑے کا نام کیا ہے؟",
    "options": ["Kiswah", "Ihram", "Qamis", "Rida"],
    "optionsUrdu": ["کسوہ", "احرام", "قمیص", "رداء"],
    "correctAnswer": "Kiswah",
    "correctAnswerUrdu": "کسوہ",
    "explanation":
        "The Kiswah is the black cloth that covers the Kaaba, embroidered with verses from the Quran in gold.",
    "explanationUrdu":
        "کسوہ وہ سیاہ کپڑا ہے جو کعبہ کو ڈھانپتا ہے، اس پر قرآن کی آیات سونے سے کڑھائی کی جاتی ہیں۔"
  },
  {
    "question": "Which prophet was known for his beautiful voice in reciting?",
    "questionUrdu": "کون سا نبی اپنی خوبصورت آواز میں تلاوت کے لئے مشہور تھا؟",
    "options": ["Dawud (AS)", "Sulaiman (AS)", "Musa (AS)", "Harun (AS)"],
    "optionsUrdu": [
      "داوود (علیہ السلام)",
      "سلیمان (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "ہارون (علیہ السلام)"
    ],
    "correctAnswer": "Dawud (AS)",
    "correctAnswerUrdu": "داوود (علیہ السلام)",
    "explanation":
        "Prophet Dawud (David) was blessed with a beautiful voice that would make mountains and birds join him in praise.",
    "explanationUrdu":
        "نبی داوود (علیہ السلام) کو ایسی خوبصورت آواز سے نوازا گیا تھا کہ پہاڑ اور پرندے ان کے ساتھ حمد میں شامل ہو جاتے تھے۔"
  },
  {
    "question": "What is the reward for reading the entire Quran?",
    "questionUrdu": "مکمل قرآن پڑھنے کا کیا اجر ہے؟",
    "options": [
      "700 good deeds",
      "1000 good deeds",
      "Countless rewards",
      "Forgiveness of sins"
    ],
    "optionsUrdu": [
      "700 نیکیاں",
      "1000 نیکیاں",
      "لامحدود اجر",
      "گناہوں کی معافی"
    ],
    "correctAnswer": "Countless rewards",
    "correctAnswerUrdu": "لامحدود اجر",
    "explanation":
        "Reading the Quran brings countless rewards, with each letter earning 10 good deeds according to hadith.",
    "explanationUrdu":
        "قرآن پڑھنے سے لامحدود اجر ملتا ہے، حدیث کے مطابق ہر حرف پر 10 نیکیاں ملتی ہیں۔"
  },
  {
    "question":
        "Which prophet was given the ability to bring the dead back to life?",
    "questionUrdu": "کون سے نبی کو مردوں کو زندہ کرنے کی صلاحیت دی گئی؟",
    "options": ["Musa (AS)", "Isa (AS)", "Sulaiman (AS)", "Ibrahim (AS)"],
    "optionsUrdu": [
      "موسیٰ (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "سلیمان (علیہ السلام)",
      "ابراہیم (علیہ السلام)"
    ],
    "correctAnswer": "Isa (AS)",
    "correctAnswerUrdu": "عیسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Isa (Jesus) was given the miracle to bring the dead back to life with Allah's permission.",
    "explanationUrdu":
        "نبی عیسیٰ (علیہ السلام) کو اللہ کی اجازت سے مردوں کو زندہ کرنے کا معجزہ دیا گیا تھا۔"
  },
  {
    "question": "What is the Islamic month of pilgrimage?",
    "questionUrdu": "حج کا اسلامی مہینہ کون سا ہے؟",
    "options": ["Muharram", "Ramadan", "Dhul Hijjah", "Shawwal"],
    "optionsUrdu": ["محرم", "رمضان", "ذوالحجہ", "شوال"],
    "correctAnswer": "Dhul Hijjah",
    "correctAnswerUrdu": "ذوالحجہ",
    "explanation":
        "Dhul Hijjah is the 12th month of the Islamic calendar when Hajj pilgrimage is performed.",
    "explanationUrdu":
        "ذوالحجہ اسلامی کیلنڈر کا 12 واں مہینہ ہے جب حج کی ادائیگی کی جاتی ہے۔"
  },
  {
    "question": "How many sons did Prophet Muhammad (PBUH) have?",
    "questionUrdu": "نبی محمد صلی اللہ علیہ وسلم کے کتنے بیٹوں تھے؟",
    "options": ["2", "3", "4", "5"],
    "optionsUrdu": ["2", "3", "4", "5"],
    "correctAnswer": "3",
    "correctAnswerUrdu": "3",
    "explanation":
        "Prophet Muhammad (PBUH) had three sons: Qasim, Abdullah (Tayyib, Tahir), and Ibrahim, all died in childhood.",
    "explanationUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کے تین بیٹوں تھے: قاسم، عبداللہ (طیّب، طاہر)، اور ابراہیم، سب بچپن میں وفات پا گئے۔"
  },
  {
    "question": "Which battle was fought to defend Medina with a trench?",
    "questionUrdu": "مدینہ کے دفاع کے لئے خندق کے ساتھ کون سی لڑائی لڑی گئی؟",
    "options": [
      "Battle of Badr",
      "Battle of Uhud",
      "Battle of Khandaq",
      "Battle of Khaybar"
    ],
    "optionsUrdu": ["جنگ بدر", "جنگ احد", "جنگ خندق", "جنگ خیبر"],
    "correctAnswer": "Battle of Khandaq",
    "correctAnswerUrdu": "جنگ خندق",
    "explanation":
        "The Battle of Khandaq (Trench) was fought when Muslims dug a trench around Medina for defense.",
    "explanationUrdu":
        "جنگ خندق اس وقت لڑی گئی جب مسلمانوں نے مدینہ کے گرد دفاع کے لئے خندق کھودی۔"
  },
  {
    "question": "What is the name of Prophet Muhammad's (PBUH) wet nurse?",
    "questionUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کی دودھ پلانے والی دایہ کا نام کیا تھا؟",
    "options": ["Aminah", "Halimah", "Thuwaibah", "Barakah"],
    "optionsUrdu": ["آمنہ", "حلیمہ", "ثویبہ", "برکہ"],
    "correctAnswer": "Halimah",
    "correctAnswerUrdu": "حلیمہ",
    "explanation":
        "Halimah as-Sa'diyyah was the Bedouin woman who nursed Prophet Muhammad (PBUH) in his early years.",
    "explanationUrdu":
        "حلیمہ السعدیہ وہ بدوی خاتون تھیں جنہوں نے نبی محمد صلی اللہ علیہ وسلم کو ان کے ابتدائی سالوں میں دودھ پلایا۔"
  },
  {
    "question": "Which angel brings good news to the prophets?",
    "questionUrdu": "کون سا فرشتہ انبیاء کے لئے خوشخبری لاتا ہے؟",
    "options": ["Jibreel (AS)", "Mikail (AS)", "Israfil (AS)", "Azrail (AS)"],
    "optionsUrdu": [
      "جبریل (علیہ السلام)",
      "میکائیل (علیہ السلام)",
      "اسرافیل (علیہ السلام)",
      "عزرائیل (علیہ السلام)"
    ],
    "correctAnswer": "Jibreel (AS)",
    "correctAnswerUrdu": "جبریل (علیہ السلام)",
    "explanation":
        "Angel Jibreel (Gabriel) brought revelations and good news from Allah to the prophets.",
    "explanationUrdu":
        "فرشتہ جبریل (علیہ السلام) انبیاء کے لئے اللہ سے وحی اور خوشخبری لاتے تھے۔"
  },
  {
    "question":
        "What is the term for the crescent moon that determines Islamic months?",
    "questionUrdu":
        "اسلامی مہینوں کا تعین کرنے والے ہلال کے لئے اصطلاح کیا ہے؟",
    "options": ["Hilal", "Qamar", "Najm", "Shams"],
    "optionsUrdu": ["ہلال", "قمر", "نجم", "شمس"],
    "correctAnswer": "Hilal",
    "correctAnswerUrdu": "ہلال",
    "explanation":
        "Hilal is the Arabic term for the new crescent moon that marks the beginning of Islamic months.",
    "explanationUrdu":
        "ہلال عربی اصطلاح ہے جو نئے ہلال چاند کے لئے ہے جو اسلامی مہینوں کے آغاز کی نشاندہی کرتا ہے۔"
  },
  {
    "question":
        "Which prophet was given a scripture that could not be changed?",
    "questionUrdu":
        "کون سے ن exfoliation نبی کو ایسی کتاب دی گئی جو تبدیل نہیں ہو سکتی تھی؟",
    "options": ["All prophets", "Muhammad (PBUH)", "Isa (AS)", "Musa (AS)"],
    "optionsUrdu": [
      "تمام انبیاء",
      "محمد صلی اللہ علیہ وسلم",
      "عیسیٰ (علیہ السلام)",
      "موسیٰ (علیہ السلام)"
    ],
    "correctAnswer": "Muhammad (PBUH)",
    "correctAnswerUrdu": "محمد صلی اللہ علیہ وسلم",
    "explanation":
        "The Quran given to Prophet Muhammad (PBUH) is the only scripture that Allah has promised to protect from change.",
    "explanationUrdu":
        "قرآن جو نبی محمد صلی اللہ علیہ وسلم کو دیا گیا وہ واحد کتاب ہے جسے اللہ نے تبدیل ہونے سے محفوظ رکھنے کا وعدہ کیا ہے۔"
  },
  {
    "question": "What is the Arabic word for repentance?",
    "questionUrdu": "توبہ کے لئے عربی لفظ کیا ہے؟",
    "options": ["Istighfar", "Tawbah", "Dua", "Dhikr"],
    "optionsUrdu": ["استغفار", "توبہ", "دعا", "ذکر"],
    "correctAnswer": "Tawbah",
    "correctAnswerUrdu": "توبہ",
    "explanation":
        "Tawbah means repentance - turning back to Allah and seeking His forgiveness for sins.",
    "explanationUrdu":
        "توبہ کا مطلب ہے توبہ کرنا - اللہ کی طرف واپس لوٹنا اور گناہوں کی معافی مانگنا۔"
  },
  {
    "question": "Which companion was known for his knowledge of Islamic law?",
    "questionUrdu": "کون سا صحابی اسلامی قانون کے علم کے لئے مشہور تھا؟",
    "options": [
      "Abu Bakr (RA)",
      "Umar (RA)",
      "Ibn Abbas (RA)",
      "Abu Hurairah (RA)"
    ],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "عمر (رضی اللہ عنہ)",
      "ابن عباس (رضی اللہ عنہ)",
      "ابو ہریرہ (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Ibn Abbas (RA)",
    "correctAnswerUrdu": "ابن عباس (رضی اللہ عنہ)",
    "explanation":
        "Abdullah ibn Abbas (RA) was called \"Hibr al-Ummah\" (the learned one of the nation) for his vast knowledge.",
    "explanationUrdu":
        "عبداللہ بن عباس (رضی اللہ عنہ) کو ان کے وسیع علم کی وجہ سے \"حبر الامہ\" (امہ کا عالم) کہا جاتا تھا۔"
  },
  {
    "question": "What is the name of the Night of Ascension?",
    "questionUrdu": "معراج کی رات کا نام کیا ہے؟",
    "options": [
      "Laylat al-Qadr",
      "Laylat al-Miraj",
      "Laylat al-Bara'ah",
      "Laylat al-Isra"
    ],
    "optionsUrdu": [
      "لیلۃ القدر",
      "لیلۃ المعراج",
      "لیلۃ البراءہ",
      "لیلۃ الاسراء"
    ],
    "correctAnswer": "Laylat al-Miraj",
    "correctAnswerUrdu": "لیلۃ المعراج",
    "explanation":
        "Laylat al-Miraj is the Night of Ascension when Prophet Muhammad (PBUH) was taken through the heavens.",
    "explanationUrdu":
        "لیلۃ المعراج وہ رات ہے جب نبی محمد صلی اللہ علیہ وسلم کو آسمانوں کی سیر کرائی گئی۔"
  },
  {
    "question": "Which prophet was ordered to build an altar on Mount Moriah?",
    "questionUrdu":
        "کون سے نبی کو جبل موریہ پر قربان گاہ بنانے کا حکم دیا گیا؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Dawud (AS)", "Sulaiman (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "داوود (علیہ السلام)",
      "سلیمان (علیہ السلام)"
    ],
    "correctAnswer": "Ibrahim (AS)",
    "correctAnswerUrdu": "ابراہیم (علیہ السلام)",
    "explanation":
        "Prophet Ibrahim (AS) was ordered to sacrifice his son on Mount Moriah, where later the Temple was built.",
    "explanationUrdu":
        "نبی ابراہیم (علیہ السلام) کو جبل موریہ پر اپنے بیٹے کی قربانی کا حکم دیا گیا، جہاں بعد میں ہیکل بنایا گیا۔"
  },
  {
    "question": "What is the term for the person who calls Muslims to prayer?",
    "questionUrdu": "مسلمانوں کو نماز کے لئے بلانے والے شخص کو کیا کہتے ہیں؟",
    "options": ["Imam", "Muezzin", "Khatib", "Qari"],
    "optionsUrdu": ["امام", "مؤذن", "خطیب", "قاری"],
    "correctAnswer": "Muezzin",
    "correctAnswerUrdu": "مؤذن",
    "explanation":
        "A Muezzin (Mu'adhdhin) is the person who calls Muslims to prayer by reciting the Adhan.",
    "explanationUrdu":
        "مؤذن (معاذین) وہ شخص ہے جو اذان پڑھ کر مسلمانوں کو نماز کے لئے بلاتا ہے۔"
  },
  {
    "question": "How many times is the word \"Quran\" mentioned in the Quran?",
    "questionUrdu": "قرآن میں لفظ \"قرآن\" کتنی بار ذکر ہوا ہے؟",
    "options": ["50", "60", "70", "80"],
    "optionsUrdu": ["50", "60", "70", "80"],
    "correctAnswer": "70",
    "correctAnswerUrdu": "70",
    "explanation":
        "The word \"Quran\" appears approximately 70 times in the Quran itself.",
    "explanationUrdu": "لفظ \"قرآن\" خود قرآن میں تقریباً 70 بار آیا ہے۔"
  },
  {
    "question": "Which prophet was given the title \"Khatam an-Nabiyyin\"?",
    "questionUrdu": "کون سے نبی کو \"خاتم النبیین\" کا لقب دیا گیا؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Isa (AS)", "Muhammad (PBUH)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "محمد صلی اللہ علیہ وسلم"
    ],
    "correctAnswer": "Muhammad (PBUH)",
    "correctAnswerUrdu": "محمد صلی اللہ علیہ وسلم",
    "explanation":
        "Prophet Muhammad (PBUH) is called \"Khatam an-Nabiyyin\" meaning the Seal of the Prophets - the final messenger.",
    "explanationUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کو \"خاتم النبیین\" کہا جاتا ہے جس کا مطلب ہے نبیوں کا مہر - آخری رسول۔"
  },
  {
    "question": "What is the Islamic term for the life of this world?",
    "questionUrdu": "اس دنیا کی زندگی کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Akhirah", "Dunya", "Barzakh", "Jannah"],
    "optionsUrdu": ["آخرت", "دنیا", "برزخ", "جنت"],
    "correctAnswer": "Dunya",
    "correctAnswerUrdu": "دنیا",
    "explanation":
        "Dunya refers to this worldly life, as opposed to Akhirah which is the afterlife.",
    "explanationUrdu":
        "دنیا سے مراد اس دنیا کی زندگی ہے، جبکہ آخرت سے مراد آخرت ہے۔"
  },
  {
    "question": "Which Surah is known as the \"Mother of the Book\"?",
    "questionUrdu": "کون سی سورہ \"ام الکتاب\" کے نام سے جانی جاتی ہے؟",
    "options": ["Al-Baqarah", "Al-Fatiha", "Al-Ikhlas", "Yasin"],
    "optionsUrdu": ["البقرہ", "الفاتحہ", "الاخلاص", "یٰسین"],
    "correctAnswer": "Al-Fatiha",
    "correctAnswerUrdu": "الفاتحہ",
    "explanation":
        "Surah Al-Fatiha is called \"Umm al-Kitab\" (Mother of the Book) as it contains the essence of the Quran.",
    "explanationUrdu":
        "سورہ الفاتحہ کو \"ام الکتاب\" (کتاب کی ماں) کہا جاتا ہے کیونکہ اس میں قرآن کا جوہر شامل ہے۔"
  },
  {
    "question":
        "What is the name of the treaty signed between Muslims and Meccans?",
    "questionUrdu":
        "مسلمانوں اور مکہ والوں کے درمیان دستخط شدہ معاہدے کا نام کیا ہے؟",
    "options": [
      "Treaty of Badr",
      "Treaty of Hudaybiyyah",
      "Treaty of Uhud",
      "Treaty of Tabuk"
    ],
    "optionsUrdu": ["معاہدہ بدر", "معاہدہ حدیبیہ", "معاہدہ احد", "معاہدہ تبوک"],
    "correctAnswer": "Treaty of Hudaybiyyah",
    "correctAnswerUrdu": "معاہدہ حدیبیہ",
    "explanation":
        "The Treaty of Hudaybiyyah was a peace agreement between Muslims and the Meccan tribes.",
    "explanationUrdu":
        "معاہدہ حدیبیہ مسلمانوں اور مکہ کے قبائل کے درمیان ایک امن معاہدہ تھا۔"
  },
  {
    "question": "Which prophet was given the power to control jinn?",
    "questionUrdu": "کون سے نبی کو جنوں پر کنٹرول کرنے کی طاقت دی گئی؟",
    "options": [
      "Sulaiman (AS)",
      "Dawud (AS)",
      "Muhammad (PBUH)",
      "Ibrahim (AS)"
    ],
    "optionsUrdu": [
      "سلیمان (علیہ السلام)",
      "داوود (علیہ السلام)",
      "محمد صلی اللہ علیہ وسلم",
      "ابراہیم (علیہ السلام)"
    ],
    "correctAnswer": "Sulaiman (AS)",
    "correctAnswerUrdu": "سلیمان (علیہ السلام)",
    "explanation":
        "Prophet Sulaiman (Solomon) was given authority over jinn as part of his unique kingdom.",
    "explanationUrdu":
        "نبی سلیمان (علیہ السلام) کو ان کی منفرد بادشاہت کے حصے کے طور پر جنوں پر اختیار دیا گیا تھا۔"
  },
  {
    "question": "What is the Arabic term for Islamic jurisprudence?",
    "questionUrdu": "اسلامی فقہ کے لئے عربی اصطلاح کیا ہے؟",
    "options": ["Fiqh", "Hadith", "Tafsir", "Aqidah"],
    "optionsUrdu": ["فقہ", "حدیث", "تفسیر", "عقیدہ"],
    "correctAnswer": "Fiqh",
    "correctAnswerUrdu": "فقہ",
    "explanation":
        "Fiqh is Islamic jurisprudence - the understanding and application of Islamic law derived from Quran and Sunnah.",
    "explanationUrdu":
        "فقہ اسلامی فقہ ہے - قرآن اور سنت سے اخذ کردہ اسلامی قانون کی سمجھ اور اطلاق۔"
  },
  {
    "question": "Which prophet was known as \"The Patient One\"?",
    "questionUrdu": "کون سا نبی \"صابر\" کے نام سے مشہور تھا؟",
    "options": ["Ayyub (AS)", "Yaqub (AS)", "Yusuf (AS)", "Nuh (AS)"],
    "optionsUrdu": [
      "ایوب (علیہ السلام)",
      "یعقوب (علیہ السلام)",
      "یوسف (علیہ السلام)",
      "نوح (علیہ السلام)"
    ],
    "correctAnswer": "Ayyub (AS)",
    "correctAnswerUrdu": "ایوب (علیہ السلام)",
    "explanation":
        "Prophet Ayyub (Job) is especially known for his extraordinary patience (sabr) during severe trials.",
    "explanationUrdu":
        "حضرت ایوب (ایوب) خاص طور پر سخت آزمائشوں کے دوران اپنے غیر معمولی صبر (صبر) کے لئے مشہور ہیں۔"
  },
  {
    "question":
        "What is the name of the battle where Muslims first used catapults?",
    "questionUrdu":
        "وہ لڑائی کس کا نام ہے جہاں مسلمانوں نے پہلی بار منجنیق استعمال کی؟",
    "options": [
      "Battle of Badr",
      "Battle of Uhud",
      "Siege of Taif",
      "Battle of Khandaq"
    ],
    "optionsUrdu": ["جنگ بدر", "جنگ احد", "محاصرہ طائف", "جنگ خندق"],
    "correctAnswer": "Siege of Taif",
    "correctAnswerUrdu": "محاصرہ طائف",
    "explanation":
        "During the Siege of Taif, Muslims used catapults for the first time in Islamic warfare.",
    "explanationUrdu":
        "محاصرہ طائف کے دوران، مسلمانوں نے اسلامی جنگ میں پہلی بار منجنیق استعمال کی۔"
  },
  {
    "question": "Which companion was known for narrating the most hadiths?",
    "questionUrdu":
        "کون سا صحابی سب سے زیادہ احادیث بیان کرنے کے لئے مشہور تھا؟",
    "options": ["Abu Bakr (RA)", "Umar (RA)", "Abu Hurairah (RA)", "Ali (RA)"],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "عمر (رضی اللہ عنہ)",
      "ابو ہریرہ (رضی اللہ عنہ)",
      "علی (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Abu Hurairah (RA)",
    "correctAnswerUrdu": "ابو ہریرہ (رضی اللہ عنہ)",
    "explanation":
        "Abu Hurairah (RA) narrated over 5,000 hadiths, more than any other companion.",
    "explanationUrdu":
        "ابو ہریرہ (رضی اللہ عنہ) نے 5,000 سے زیادہ احادیث بیان کیں، جو کسی بھی دوسرے صحابی سے زیادہ ہیں۔"
  },
  {
    "question": "What is the term for the direction towards Mecca?",
    "questionUrdu": "مکہ کی طرف رخ کے لئے اصطلاح کیا ہے؟",
    "options": ["Mihrab", "Qibla", "Minbar", "Minaret"],
    "optionsUrdu": ["محراب", "قبلہ", "منبر", "مینار"],
    "correctAnswer": "Qibla",
    "correctAnswerUrdu": "قبلہ",
    "explanation":
        "Qibla is the direction Muslims face during prayer, which is towards the Kaaba in Mecca.",
    "explanationUrdu":
        "قبلہ وہ سمت ہے جس کی طرف مسلمان نماز کے دوران رخ کرتے ہیں، جو مکہ میں کعبہ کی طرف ہے۔"
  },
  {
    "question": "Which prophet was given a ring that controlled the jinn?",
    "questionUrdu":
        "کون سے نبی کو ایک انگوٹھی دی گئی جس سے جنوں پر کنٹرول ہوتا تھا؟",
    "options": ["Sulaiman (AS)", "Dawud (AS)", "Ibrahim (AS)", "Musa (AS)"],
    "optionsUrdu": [
      "سلیمان (علیہ السلام)",
      "داوود (علیہ السلام)",
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)"
    ],
    "correctAnswer": "Sulaiman (AS)",
    "correctAnswerUrdu": "سلیمان (علیہ السلام)",
    "explanation":
        "Prophet Sulaiman (Solomon) was given a special ring that gave him power over jinn and demons.",
    "explanationUrdu":
        "نبی سلیمان (علیہ السلام) کو ایک خاص انگوٹھی دی گئی جس سے انہیں جنوں اور شیاطین پر اختیار حاصل تھا۔"
  },
  {
    "question": "What is the Islamic greeting when someone sneezes?",
    "questionUrdu": "جب کوئی چھینکتا ہے تو اسلامی سلام کیا ہے؟",
    "options": ["Bless you", "Alhamdulillah", "Yarhamukallah", "Subhanallah"],
    "optionsUrdu": ["تم پر برکت ہو", "الحمدللہ", "یرحمک اللہ", "سبحان اللہ"],
    "correctAnswer": "Yarhamukallah",
    "correctAnswerUrdu": "یرحمک اللہ",
    "explanation":
        "When someone says \"Alhamdulillah\" after sneezing, others respond with \"Yarhamukallah\" (May Allah have mercy on you).",
    "explanationUrdu":
        "جب کوئی چھینکنے کے بعد \"الحمدللہ\" کہتا ہے، تو دوسرے \"یرحمک اللہ\" (اللہ تم پر رحم کرے) کہتے ہیں۔"
  },
  {
    "question":
        "Which prophet was thrown into a burning furnace with his companions?",
    "questionUrdu":
        "کون سا نبی اپنے ساتھیوں کے ساتھ جلتی ہوئی بھٹی میں پھینکا گیا؟",
    "options": [
      "Ibrahim (AS)",
      "Musa (AS)",
      "Daniel (AS)",
      "This refers to other righteous people, not a prophet"
    ],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "دانیال (علیہ السلام)",
      "یہ دوسرے نیک لوگوں سے متعلق ہے، نبی سے نہیں"
    ],
    "correctAnswer": "This refers to other righteous people, not a prophet",
    "correctAnswerUrdu": "یہ دوسرے نیک لوگوں سے متعلق ہے، نبی سے نہیں",
    "explanation":
        "The story of being thrown into a furnace refers to the companions of Prophet Daniel or other righteous people, not specifically a prophet mentioned in Quran.",
    "explanationUrdu":
        "جلتی ہوئی بھٹی میں پھینکنے کی کہانی نبی دانیال یا دیگر نیک لوگوں کے ساتھیوں سے متعلق ہے، نہ کہ قرآن میں ذکر کردہ کسی نبی سے۔"
  },
  {
    "question": "What is the name of the Prophet's (PBUH) favorite daughter?",
    "questionUrdu": "نبی صلی اللہ علیہ وسلم کی پسندیدہ بیٹی کا نام کیا تھا؟",
    "options": [
      "Zainab (RA)",
      "Ruqayyah (RA)",
      "Fatimah (RA)",
      "Umm Kulthum (RA)"
    ],
    "optionsUrdu": [
      "زینب (رضی اللہ عنہا)",
      "رقیہ (رضی اللہ عنہا)",
      "فاطمہ (رضی اللہ عنہا)",
      "ام کلثوم (رضی اللہ عنہا)"
    ],
    "correctAnswer": "Fatimah (RA)",
    "correctAnswerUrdu": "فاطمہ (رضی اللہ عنہا)",
    "explanation":
        "Fatimah (RA) was the beloved daughter of Prophet Muhammad (PBUH) and wife of Ali (RA).",
    "explanationUrdu":
        "فاطمہ (رضی اللہ عنہا) نبی محمد صلی اللہ علیہ وسلم کی پیاری بیٹی اور علی (رضی اللہ عنہ) کی بیوی تھیں۔"
  },
  {
    "question": "Which Surah mentions the story of the Cave Dwellers?",
    "questionUrdu": "کون سی سورہ غار والوں کی کہانی کا ذکر کرتی ہے؟",
    "options": ["Al-Kahf", "Al-Anfal", "At-Tawbah", "Yunus"],
    "optionsUrdu": ["الکہف", "الانفال", "التوبہ", "یونس"],
    "correctAnswer": "Al-Kahf",
    "correctAnswerUrdu": "الکہف",
    "explanation":
        "Surah Al-Kahf (The Cave) tells the story of the young believers who slept in a cave for many years.",
    "explanationUrdu":
        "سورہ الکہف (غار) ان نوجوان مومنوں کی کہانی سناتی ہے جو کئی سالوں تک غار میں سوئے رہے۔"
  },
  {
    "question":
        "What is the Arabic term for the place where Prophet Muhammad (PBUH) used to pray?",
    "questionUrdu":
        "نبی محمد صلی اللہ علیہ وسلم جہاں نماز پڑھتے تھے اس جگہ کے لئے عربی اصطلاح کیا ہے؟",
    "options": ["Mihrab", "Musalla", "Rawdah", "All of the above"],
    "optionsUrdu": ["محراب", "مصلیٰ", "روضہ", "مذکورہ بالا سب"],
    "correctAnswer": "All of the above",
    "correctAnswerUrdu": "مذکورہ بالا سب",
    "explanation":
        "Mihrab (prayer niche), Musalla (place of prayer), and Rawdah (garden - referring to the area between his house and pulpit) are all terms related to the Prophet's prayer areas.",
    "explanationUrdu":
        "محراب (نماز کی جگہ)، مصلیٰ (نماز کی جگہ)، اور روضہ (باغ - ان کے گھر اور منبر کے درمیان کا علاقہ) سب نبی کی نماز کی جگہوں سے متعلق اصطلاحات ہیں۔"
  },
  {
    "question": "Which prophet was saved from the whale's belly?",
    "questionUrdu": "کون سا نبی وہیل کے پیٹ سے بچایا گیا؟",
    "options": ["Yunus (AS)", "Nuh (AS)", "Lut (AS)", "Hud (AS)"],
    "optionsUrdu": [
      "یونس (علیہ السلام)",
      "نوح (علیہ السلام)",
      "لوط (علیہ السلام)",
      "ہود (علیہ السلام)"
    ],
    "correctAnswer": "Yunus (AS)",
    "correctAnswerUrdu": "یونس (علیہ السلام)",
    "explanation":
        "Prophet Yunus (Jonah) was saved by Allah from inside the whale after he repented and praised Allah.",
    "explanationUrdu":
        "نبی یونس (علیہ السلام) کو اللہ نے توبہ کرنے اور اللہ کی حمد کرنے کے بعد وہیل کے پیٹ سے بچایا۔"
  },
  {
    "question": "What is the term for Islamic religious endowment?",
    "questionUrdu": "اسلامی مذہبی وقف کے لئے اصطلاح کیا ہے؟",
    "options": ["Zakat", "Sadaqah", "Waqf", "Khums"],
    "optionsUrdu": ["زکوٰۃ", "صدقہ", "وقف", "خمس"],
    "correctAnswer": "Waqf",
    "correctAnswerUrdu": "وقف",
    "explanation":
        "Waqf is an Islamic religious endowment - a property or asset donated for religious or charitable purposes.",
    "explanationUrdu":
        "وقف ایک اسلامی مذہبی وقف ہے - مذہبی یا خیراتی مقاصد کے لئے عطیہ کردہ جائیداد یا اثاثہ۔"
  },
  {
    "question": "Which prophet was known for making armor and weapons?",
    "questionUrdu": "کون سا نبی زرہ اور ہتھیار بنانے کے لئے مشہور تھا؟",
    "options": ["Dawud (AS)", "Sulaiman (AS)", "Nuh (AS)", "Ibrahim (AS)"],
    "optionsUrdu": [
      "داوود (علیہ السلام)",
      "سلیمان (علیہ السلام)",
      "نوح (علیہ السلام)",
      "ابراہیم (علیہ السلام)"
    ],
    "correctAnswer": "Dawud (AS)",
    "correctAnswerUrdu": "داوود (علیہ السلام)",
    "explanation":
        "Prophet Dawud (David) was skilled in making armor and weapons, and Allah made iron soft for him to work with.",
    "explanationUrdu":
        "نبی داوود (علیہ السلام) زرہ اور ہتھیار بنانے میں ماہر تھے، اور اللہ نے ان کے لئے لوہے کو نرم کیا تاکہ وہ اس کے ساتھ کام کر سکیں۔"
  },
  {
    "question":
        "What is the last thing Prophet Muhammad (PBUH) said before he died?",
    "questionUrdu":
        "نبی محمد صلی اللہ علیہ وسلم نے مرنے سے پہلے آخری بات کیا کہی؟",
    "options": [
      "La ilaha illa Allah",
      "Ar-Rafiq al-A'la",
      "Allahumma ighfir li",
      "Subhanallah"
    ],
    "optionsUrdu": [
      "لا الہ الا اللہ",
      "الرفیق الاعلیٰ",
      "اللھم اغفر لی",
      "سبحان اللہ"
    ],
    "correctAnswer": "Ar-Rafiq al-A'la",
    "correctAnswerUrdu": "الرفیق الاعلیٰ",
    "explanation":
        "The last words of Prophet Muhammad (PBUH) were \"Ar-Rafiq al-A'la\" meaning \"The Highest Companion\" referring to Allah.",
    "explanationUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کے آخری الفاظ \"الرفیق الاعلیٰ\" تھے جس کا مطلب ہے \"سب سے اعلیٰ ساتھی\" جو اللہ کی طرف اشارہ کرتا ہے۔"
  },
  {
    "question": "Which companion was the first to be martyred in Islam?",
    "questionUrdu": "اسلام میں سب سے پہلے کون سا صحابی شہید ہوا؟",
    "options": ["Hamza (RA)", "Sumayya (RA)", "Yasir (RA)", "Mus'ab (RA)"],
    "optionsUrdu": [
      "حمزہ (رضی اللہ عنہ)",
      "سمیہ (رضی اللہ عنہا)",
      "یاسر (رضی اللہ عنہ)",
      "مصعب (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Sumayya (RA)",
    "correctAnswerUrdu": "سمیہ (رضی اللہ عنہا)",
    "explanation":
        "Sumayya bint Khubbat (RA) was the first martyr in Islam, killed for refusing to renounce her faith.",
    "explanationUrdu":
        "سمیہ بنت خباط (رضی اللہ عنہا) اسلام کی پہلی شہید تھیں، جو اپنے ایمان سے دستبردار ہونے سے انکار کرنے پر قتل ہوئیں۔"
  },
  {
    "question": "What is the Islamic term for the consensus of scholars?",
    "questionUrdu": "علماء کے اجماع کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Ijma", "Qiyas", "Ijtihad", "Taqlid"],
    "optionsUrdu": ["اجماع", "قیاس", "اجتہاد", "تقلید"],
    "correctAnswer": "Ijma",
    "correctAnswerUrdu": "اجماع",
    "explanation":
        "Ijma refers to the consensus of Islamic scholars on religious matters, considered a source of Islamic law.",
    "explanationUrdu":
        "اجماع سے مراد اسلامی علماء کا مذہبی معاملات پر اتفاق رائے ہے، جو اسلامی قانون کا ایک ذریعہ سمجھا جاتا ہے۔"
  },
  {
    "question": "Which prophet built the Ark to save believers from the flood?",
    "questionUrdu": "کون سے نبی نے مومنوں کو طوفان سے بچانے کے لئے کشتی بنائی؟",
    "options": ["Ibrahim (AS)", "Nuh (AS)", "Lut (AS)", "Hud (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "نوح (علیہ السلام)",
      "لوط (علیہ السلام)",
      "ہود (علیہ السلام)"
    ],
    "correctAnswer": "Nuh (AS)",
    "correctAnswerUrdu": "نوح (علیہ السلام)",
    "explanation":
        "Prophet Nuh (Noah) built the Ark under Allah's guidance to save believers and animals from the great flood.",
    "explanationUrdu":
        "نبی نوح (علیہ السلام) نے اللہ کی ہدایت پر کشتی بنائی تاکہ مومنوں اور جانوروں کو عظیم طوفان سے بچایا جا سکے۔"
  },
  {
    "question": "What is the Arabic word for prayer?",
    "questionUrdu": "نماز کے لئے عربی لفظ کیا ہے؟",
    "options": ["Zakat", "Sawm", "Salah", "Hajj"],
    "optionsUrdu": ["زکوٰۃ", "صوم", "صلاة", "حج"],
    "correctAnswer": "Salah",
    "correctAnswerUrdu": "صلاة",
    "explanation":
        "Salah is the Arabic word for prayer, one of the five pillars of Islam performed five times daily.",
    "explanationUrdu":
        "صلاة نماز کے لئے عربی لفظ ہے، جو اسلام کے پانچ ستونوں میں سے ایک ہے اور دن میں پانچ بار ادا کی جاتی ہے۔"
  },
  {
    "question": "Which prophet had twelve sons who became the twelve tribes?",
    "questionUrdu": "کون سے نبی کے بارہ بیٹوں نے بارہ قبائل بنائے؟",
    "options": ["Ibrahim (AS)", "Yaqub (AS)", "Ismail (AS)", "Ishaq (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "یعقوب (علیہ السلام)",
      "اسماعیل (علیہ السلام)",
      "اسحاق (علیہ السلام)"
    ],
    "correctAnswer": "Yaqub (AS)",
    "correctAnswerUrdu": "یعقوب (علیہ السلام)",
    "explanation":
        "Prophet Yaqub (Jacob) had twelve sons who became the ancestors of the twelve tribes of Israel.",
    "explanationUrdu":
        "نبی یعقوب (علیہ السلام) کے بارہ بیٹوں نے اسرائیل کے بارہ قبائل کے آباؤ اجداد بنے۔"
  },
  {
    "question":
        "What is the name of the mountain where Prophet Musa (AS) received the Torah?",
    "questionUrdu":
        "اس پہاڑ کا نام کیا ہے جہاں نبی موسیٰ (علیہ السلام) کو تورات دی گئی؟",
    "options": ["Mount Hira", "Mount Sinai", "Mount Uhud", "Mount Arafat"],
    "optionsUrdu": ["جبل حرا", "جبل سینا", "جبل احد", "جبل عرفات"],
    "correctAnswer": "Mount Sinai",
    "correctAnswerUrdu": "جبل سینا",
    "explanation":
        "Prophet Musa (Moses) received the Torah from Allah on Mount Sinai (Jabal Sina).",
    "explanationUrdu":
        "نبی موسیٰ (علیہ السلام) کو اللہ سے جبل سینا (جبل سینا) پر تورات دی گئی۔"
  },
  {
    "question": "Which companion was known as \"The Generous\"?",
    "questionUrdu": "کون سا صحابی \"سخی\" کے نام سے مشہور تھا؟",
    "options": ["Abu Bakr (RA)", "Umar (RA)", "Uthman (RA)", "Ali (RA)"],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "عمر (رضی اللہ عنہ)",
      "عثمان (رضی اللہ عنہ)",
      "علی (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Uthman (RA)",
    "correctAnswerUrdu": "عثمان (رضی اللہ عنہ)",
    "explanation":
        "Uthman ibn Affan (RA) was known for his generosity, often called \"Dhun-Nurayn\" and \"Al-Ghani\" (The Generous).",
    "explanationUrdu":
        "عثمان بن عفان (رضی اللہ عنہ) اپنی سخاوت کے لئے مشہور تھے، جنہیں اکثر \"ذوالنورین\" اور \"الغنی\" (سخی) کہا جاتا تھا۔"
  },
  {
    "question": "What is the Islamic term for the unity of Allah?",
    "questionUrdu": "اللہ کی وحدانیت کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Shirk", "Tawheed", "Kufr", "Iman"],
    "optionsUrdu": ["شرک", "توحید", "کفر", "ایمان"],
    "correctAnswer": "Tawheed",
    "correctAnswerUrdu": "توحید",
    "explanation":
        "Tawheed is the fundamental Islamic doctrine of the oneness and unity of Allah.",
    "explanationUrdu":
        "توحید اللہ کی وحدانیت اور یکتائی کا بنیادی اسلامی عقیدہ ہے۔"
  },
  {
    "question": "Which Surah was revealed during the Night Journey (Isra)?",
    "questionUrdu": "شب معراج (اسراء) کے دوران کون سی سورہ نازل ہوئی؟",
    "options": ["Al-Isra", "Al-Najm", "Al-Miraj", "Al-Buraq"],
    "optionsUrdu": ["الاسراء", "النجم", "المعراج", "البروق"],
    "correctAnswer": "Al-Isra",
    "correctAnswerUrdu": "الاسراء",
    "explanation":
        "Surah Al-Isra (The Night Journey) was revealed about Prophet Muhammad's miraculous journey from Mecca to Jerusalem.",
    "explanationUrdu":
        "سورہ الاسراء (شب معراج) نبی محمد صلی اللہ علیہ وسلم کے مکہ سے یروشلم تک کے معجزاتی سفر کے بارے میں نازل ہوئی۔"
  },
  {
    "question":
        "How many years did Prophet Muhammad (PBUH) live in Mecca after receiving prophethood?",
    "questionUrdu":
        "نبی محمد صلی اللہ علیہ وسلم نے نبوت ملنے کے بعد مکہ میں کتنے سال گزارے؟",
    "options": ["10 years", "13 years", "15 years", "20 years"],
    "optionsUrdu": ["10 سال", "13 سال", "15 سال", "20 سال"],
    "correctAnswer": "13 years",
    "correctAnswerUrdu": "13 سال",
    "explanation":
        "Prophet Muhammad (PBUH) preached in Mecca for 13 years before migrating to Medina.",
    "explanationUrdu":
        "نبی محمد صلی اللہ علیہ وسلم نے مدینہ ہجرت کرنے سے پہلے 13 سال تک مکہ میں تبلیغ کی۔"
  },
  {
    "question":
        "What is the name of the special prayer performed during eclipses?",
    "questionUrdu": "گرہن کے دوران ادا کی جانے والی خصوصی نماز کا نام کیا ہے؟",
    "options": [
      "Salat al-Istisqa",
      "Salat al-Kusuf",
      "Salat al-Tarawih",
      "Salat al-Witr"
    ],
    "optionsUrdu": [
      "صلاة الاستسقاء",
      "صلاة الکسوف",
      "صلاة التراویح",
      "صلاة الوتر"
    ],
    "correctAnswer": "Salat al-Kusuf",
    "correctAnswerUrdu": "صلاة الکسوف",
    "explanation":
        "Salat al-Kusuf is the special prayer performed during solar or lunar eclipses.",
    "explanationUrdu":
        "صلاة الکسوف وہ خصوصی نماز ہے جو سورج یا چاند گرہن کے دوران ادا کی جاتی ہے۔"
  },
  {
    "question":
        "Which prophet was known for his wisdom in judging between people?",
    "questionUrdu":
        "کون سا نبی لوگوں کے درمیان فیصلہ کرنے میں اپنی حکمت کے لئے مشہور تھا؟",
    "options": ["Sulaiman (AS)", "Dawud (AS)", "Yusuf (AS)", "Idris (AS)"],
    "optionsUrdu": [
      "سلیمان (علیہ السلام)",
      "داوود (علیہ السلام)",
      "یوسف (علیہ السلام)",
      "ادریس (علیہ السلام)"
    ],
    "correctAnswer": "Sulaiman (AS)",
    "correctAnswerUrdu": "سلیمان (علیہ السلام)",
    "explanation":
        "Prophet Sulaiman (Solomon) was famous for his wisdom and just judgment, including the famous case of the two mothers claiming one baby.",
    "explanationUrdu":
        "نبی سلیمان (علیہ السلام) اپنی حکمت اور عادلانہ فیصلوں کے لئے مشہور تھے، جن میں ایک بچے پر دو ماؤں کے دعوے کا مشہور مقدمہ بھی شامل ہے۔"
  },
  {
    "question": "What is the Arabic term for the obligatory charity on wealth?",
    "questionUrdu": "دولت پر واجب خیرات کے لئے عربی اصطلاح کیا ہے؟",
    "options": ["Sadaqah", "Zakat", "Khums", "Waqf"],
    "optionsUrdu": ["صدقہ", "زکوٰۃ", "خمس", "وقف"],
    "correctAnswer": "Zakat",
    "correctAnswerUrdu": "زکوٰۃ",
    "explanation":
        "Zakat is the obligatory charity that Muslims must pay on their wealth annually, one of the five pillars of Islam.",
    "explanationUrdu":
        "زکوٰۃ وہ واجب خیرات ہے جو مسلمانوں کو اپنی دولت پر سالانہ ادا کرنی ہوتی ہے، جو اسلام کے پانچ ستونوں میں سے ایک ہے۔"
  },
  {
    "question": "Which prophet was swallowed by the earth for his arrogance?",
    "questionUrdu": "کون سا نبی اپنی تکبر کی وجہ سے زمین میں دھنس گیا؟",
    "options": ["This was Qarun, not a prophet", "Firaun", "Nimrod", "Haman"],
    "optionsUrdu": ["یہ قارون تھا، نبی نہیں", "فرعون", "نمرود", "ہامان"],
    "correctAnswer": "This was Qarun, not a prophet",
    "correctAnswerUrdu": "یہ قارون تھا، نبی نہیں",
    "explanation":
        "Qarun (Korah) was a wealthy man from the time of Prophet Musa who was swallowed by the earth for his arrogance, but he was not a prophet.",
    "explanationUrdu":
        "قارون (قارون) نبی موسیٰ کے زمانے کا ایک امیر آدمی تھا جو اپنی تکبر کی وجہ سے زمین میں دھنس گیا، لیکن وہ نبی نہیں تھا۔"
  },
  {
    "question": "What is the name of the special night prayer during Ramadan?",
    "questionUrdu": "رمضان کے دوران رات کی خصوصی نماز کا نام کیا ہے؟",
    "options": ["Tahajjud", "Tarawih", "Qiyam", "Witr"],
    "optionsUrdu": ["تہجد", "تراویح", "قیام", "وتر"],
    "correctAnswer": "Tarawih",
    "correctAnswerUrdu": "تراویح",
    "explanation":
        "Tarawih is the special night prayer performed in congregation during the month of Ramadan.",
    "explanationUrdu":
        "تراویح وہ خصوصی رات کی نماز ہے جو رمضان کے مہینے میں جماعت کے ساتھ ادا کی جاتی ہے۔"
  },
  {
    "question": "Which prophet was given the miracle of healing the sick?",
    "questionUrdu": "کون سے نبی کو بیماروں کو شفا دینے کا معجزہ دیا گیا؟",
    "options": ["Musa (AS)", "Isa (AS)", "Sulaiman (AS)", "Ibrahim (AS)"],
    "optionsUrdu": [
      "موسیٰ (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "سلیمان (علیہ السلام)",
      "ابراہیم (علیہ السلام)"
    ],
    "correctAnswer": "Isa (AS)",
    "correctAnswerUrdu": "عیسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Isa (Jesus) was given the miracle to heal the sick, cure lepers, and restore sight to the blind.",
    "explanationUrdu":
        "نبی عیسیٰ (علیہ السلام) کو بیماروں کو شفا دینے، کوڑھیوں کو ٹھیک کرنے اور اندھوں کو بینائی بحال کرنے کا معجزہ دیا گیا۔"
  },
  {
    "question": "What is the name of the first battle in Islamic history?",
    "questionUrdu": "اسلامی تاریخ کی پہلی لڑائی کا نام کیا ہے؟",
    "options": [
      "Battle of Uhud",
      "Battle of Badr",
      "Battle of Khandaq",
      "Battle of Khaybar"
    ],
    "optionsUrdu": ["جنگ احد", "جنگ بدر", "جنگ خندق", "جنگ خیبر"],
    "correctAnswer": "Battle of Badr",
    "correctAnswerUrdu": "جنگ بدر",
    "explanation":
        "The Battle of Badr was the first major battle fought by Muslims under Prophet Muhammad (PBUH) in 624 CE.",
    "explanationUrdu":
        "جنگ بدر اسلامی تاریخ کی پہلی بڑی لڑائی تھی جو نبی محمد صلی اللہ علیہ وسلم کی قیادت میں 624 عیسوی میں لڑی گئی۔"
  },
  {
    "question": "Which angel is responsible for maintaining the weather?",
    "questionUrdu": "کون سا فرشتہ موسم کو برقرار رکھنے کا ذمہ دار ہے؟",
    "options": ["Jibreel (AS)", "Mikail (AS)", "Israfil (AS)", "Azrail (AS)"],
    "optionsUrdu": [
      "جبریل (علیہ السلام)",
      "میکائیل (علیہ السلام)",
      "اسرافیل (علیہ السلام)",
      "عزرائیل (علیہ السلام)"
    ],
    "correctAnswer": "Mikail (AS)",
    "correctAnswerUrdu": "میکائیل (علیہ السلام)",
    "explanation":
        "Angel Mikail (Michael) is responsible for natural phenomena including weather, rain, and sustenance.",
    "explanationUrdu":
        "فرشتہ میکائیل (مایکل) فطری مظاہر بشمول موسم، بارش اور رزق کے ذمہ دار ہیں۔"
  },
  {
    "question": "What is the Arabic word for paradise?",
    "questionUrdu": "جنت کے لئے عربی لفظ کیا ہے؟",
    "options": ["Jannah", "Firdaws", "Adn", "All of the above"],
    "optionsUrdu": ["جنت", "فردوس", "عدن", "مذکورہ بالا سب"],
    "correctAnswer": "All of the above",
    "correctAnswerUrdu": "مذکورہ بالا سب",
    "explanation":
        "Paradise is called by various names in Arabic: Jannah (garden), Firdaws (highest level), and Adn (eternal abode).",
    "explanationUrdu":
        "جنت کو عربی میں مختلف ناموں سے پکارا جاتا ہے: جنت (باغ)، فردوس (اعلیٰ درجہ)، اور عدن (ابدی رہائش)۔"
  },
  {
    "question":
        "Which prophet was commanded to call his people from a mountaintop?",
    "questionUrdu":
        "کون سے نبی کو اپنی قوم کو پہاڑ کی چوٹی سے بلانے کا حکم دیا گیا؟",
    "options": ["Nuh (AS)", "Hud (AS)", "Salih (AS)", "Muhammad (PBUH)"],
    "optionsUrdu": [
      "نوح (علیہ السلام)",
      "ہود (علیہ السلام)",
      "صالح (علیہ السلام)",
      "محمد صلی اللہ علیہ وسلم"
    ],
    "correctAnswer": "Muhammad (PBUH)",
    "correctAnswerUrdu": "محمد صلی اللہ علیہ وسلم",
    "explanation":
        "Prophet Muhammad (PBUH) was commanded to climb Mount Safa and call the Meccan people to warn them about the Day of Judgment.",
    "explanationUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کو جبل صفا پر چڑھنے اور مکہ کے لوگوں کو قیامت کے دن کے بارے میں خبردار کرنے کے لئے بلانے کا حکم دیا گیا۔"
  },
  {
    "question": "What is the term for the Islamic pilgrimage garments?",
    "questionUrdu": "اسلامی حج کے لباس کے لئے اصطلاح کیا ہے؟",
    "options": ["Thobe", "Ihram", "Qamis", "Bisht"],
    "optionsUrdu": ["تھوب", "احرام", "قمیص", "بشت"],
    "correctAnswer": "Ihram",
    "correctAnswerUrdu": "احرام",
    "explanation":
        "Ihram refers to both the sacred state and the white seamless garments worn during Hajj and Umrah.",
    "explanationUrdu":
        "احرام سے مراد مقدس حالت اور حج اور عمرہ کے دوران پہنے جانے والے سفید بغیر سِلے کپڑوں دونوں کو کہتے ہیں۔"
  },
  {
    "question": "Which companion was the Prophet's (PBUH) closest friend?",
    "questionUrdu":
        "نبی صلی اللہ علیہ وسلم کا سب سے قریبی دوست کون سا صحابی تھا؟",
    "options": ["Abu Bakr (RA)", "Umar (RA)", "Uthman (RA)", "Ali (RA)"],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "عمر (رضی اللہ عنہ)",
      "عثمان (رضی اللہ عنہ)",
      "علی (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Abu Bakr (RA)",
    "correctAnswerUrdu": "ابو بکر (رضی اللہ عنہ)",
    "explanation":
        "Abu Bakr (RA) was Prophet Muhammad's closest friend and companion, often called \"As-Siddiq\" (The Truthful).",
    "explanationUrdu":
        "ابو بکر (رضی اللہ عنہ) نبی محمد صلی اللہ علیہ وسلم کے سب سے قریبی دوست اور ساتھی تھے، جنہیں اکثر \"الصدیق\" (سچا) کہا جاتا تھا۔"
  },
  {
    "question": "What is the Islamic term for the remembrance of Allah?",
    "questionUrdu": "اللہ کی یاد کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Dua", "Dhikr", "Tasbih", "Takbir"],
    "optionsUrdu": ["دعا", "ذکر", "تسبیح", "تکبیر"],
    "correctAnswer": "Dhikr",
    "correctAnswerUrdu": "ذکر",
    "explanation":
        "Dhikr means remembrance of Allah through recitation of His names, attributes, and praise.",
    "explanationUrdu":
        "ذکر سے مراد اللہ کی یاد ہے جو اس کے ناموں، صفات اور تعریف کی تلاوت کے ذریعے کی جاتی ہے۔"
  },
  {
    "question": "Which prophet was given a book that was written on tablets?",
    "questionUrdu": "کون سے نبی کو پتھر کی تختیوں پر لکھی گئی کتاب دی گئی؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Dawud (AS)", "Isa (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "داوود (علیہ السلام)",
      "عیسیٰ (علیہ السلام)"
    ],
    "correctAnswer": "Musa (AS)",
    "correctAnswerUrdu": "موسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Musa (Moses) received the Torah written on stone tablets from Allah on Mount Sinai.",
    "explanationUrdu":
        "نبی موسیٰ (علیہ السلام) کو اللہ سے جبل سینا پر پتھر کی تختیوں پر لکھی گئی تورات دی گئی۔"
  },
  {
    "question":
        "What is the name of the well that appeared for Hajar and Ismail (AS)?",
    "questionUrdu":
        "ہاجرہ اور اسماعیل (علیہ السلام) کے لئے ظاہر ہونے والے کنویں کا نام کیا ہے؟",
    "options": ["Zamzam", "Salsabil", "Kawthar", "Tasnim"],
    "optionsUrdu": ["زمزم", "سلسبیل", "کوثر", "تسنیم"],
    "correctAnswer": "Zamzam",
    "correctAnswerUrdu": "زمزم",
    "explanation":
        "The well of Zamzam miraculously appeared when Hajar was searching for water for her son Ismail (AS) in the desert.",
    "explanationUrdu":
        "زمزم کا کنواں اس وقت معجزاتی طور پر ظاہر ہوا جب ہاجرہ اپنے بیٹے اسماعیل (علیہ السلام) کے لئے صحرا میں پانی تلاش کر رہی تھیں۔"
  },
  {
    "question": "Which Surah contains the story of Prophet Yusuf (AS)?",
    "questionUrdu": "کون سی سورہ میں نبی یوسف (علیہ السلام) کی کہانی ہے؟",
    "options": ["Surah Yusuf", "Surah Maryam", "Surah Ibrahim", "Surah Nuh"],
    "optionsUrdu": ["سورہ یوسف", "سورہ مریم", "سورہ ابراہیم", "سورہ نوح"],
    "correctAnswer": "Surah Yusuf",
    "correctAnswerUrdu": "سورہ یوسف",
    "explanation":
        "Surah Yusuf (Chapter 12) tells the complete beautiful story of Prophet Yusuf (Joseph) and his trials.",
    "explanationUrdu":
        "سورہ یوسف (باب 12) نبی یوسف (علیہ السلام) اور ان کی آزمائشوں کی مکمل خوبصورت کہانی سناتی ہے۔"
  },
  {
    "question": "What is the Arabic term for the first call to prayer?",
    "questionUrdu": "نماز کے لئے پہلی پکار کے لئے عربی اصطلاح کیا ہے؟",
    "options": ["Adhan", "Iqama", "Takbir", "Tahlil"],
    "optionsUrdu": ["اذان", "اقامہ", "تکبیر", "تہلیل"],
    "correctAnswer": "Adhan",
    "correctAnswerUrdu": "اذان",
    "explanation":
        "Adhan is the first call to prayer that announces the time for each of the five daily prayers.",
    "explanationUrdu":
        "اذان وہ پہلی پکار ہے جو پانچ روزانہ نمازوں کے وقت کی اطلاع دیتی ہے۔"
  },
  {
    "question":
        "Which prophet was given the ability to understand the language of ants?",
    "questionUrdu": "کون سے نبی کو چیونٹیوں کی زبان سمجھنے کی صلاحیت دی گئی؟",
    "options": ["Dawud (AS)", "Sulaiman (AS)", "Ibrahim (AS)", "Yaqub (AS)"],
    "optionsUrdu": [
      "داوود (علیہ السلام)",
      "سلیمان (علیہ السلام)",
      "ابراہیم (علیہ السلام)",
      "یعقوب (علیہ السلام)"
    ],
    "correctAnswer": "Sulaiman (AS)",
    "correctAnswerUrdu": "سلیمان (علیہ السلام)",
    "explanation":
        "Prophet Sulaiman (Solomon) was given the ability to understand and communicate with animals, including ants.",
    "explanationUrdu":
        "نبی سلیمان (علیہ السلام) کو جانوروں، بشمول چیونٹیوں، کے ساتھ سمجھنے اور بات چیت کرنے کی صلاحیت دی گئی تھی۔"
  },
  {
    "question":
        "What is the name of the Prophet's (PBUH) uncle who raised him?",
    "questionUrdu":
        "نبی صلی اللہ علیہ وسلم کے چچا کا نام کیا تھا جنہوں نے ان کی پرورش کی؟",
    "options": ["Abbas", "Abu Talib", "Hamza", "Abu Lahab"],
    "optionsUrdu": ["عباس", "ابو طالب", "حمزہ", "ابو لہب"],
    "correctAnswer": "Abu Talib",
    "correctAnswerUrdu": "ابو طالب",
    "explanation":
        "Abu Talib, the father of Ali (RA), raised and protected Prophet Muhammad (PBUH) after his grandfather's death.",
    "explanationUrdu":
        "ابو طالب، علی (رضی اللہ عنہ) کے والد، نے نبی محمد صلی اللہ علیہ وسلم کے دادا کی وفات کے بعد ان کی پرورش اور حفاظت کی۔"
  },
  {
    "question": "Which prayer is known as the \"middle prayer\"?",
    "questionUrdu": "کون سی نماز کو \"وسطیٰ نماز\" کہا جاتا ہے؟",
    "options": ["Fajr", "Dhuhr", "Asr", "Maghrib"],
    "optionsUrdu": ["فجر", "ظہر", "عصر", "مغرب"],
    "correctAnswer": "Asr",
    "correctAnswerUrdu": "عصر",
    "explanation":
        "Asr prayer is referred to as \"As-Salat al-Wusta\" (the middle prayer) in the Quran and requires special attention.",
    "explanationUrdu":
        "عصر کی نماز کو قرآن میں \"الصلوٰۃ الوسطیٰ\" (وسطیٰ نماز) کہا جاتا ہے اور اسے خصوصی توجہ کی ضرورت ہوتی ہے۔"
  },
  {
    "question": "What is the Islamic term for destiny or divine decree?",
    "questionUrdu": "تقدیر یا الہی فیصلے کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Qadar", "Taqdeer", "Both Qadar and Taqdeer", "Maktoob"],
    "optionsUrdu": ["قدر", "تقدیر", "قدر اور تقدیر دونوں", "مکتوب"],
    "correctAnswer": "Both Qadar and Taqdeer",
    "correctAnswerUrdu": "قدر اور تقدیر دونوں",
    "explanation":
        "Both Qadar and Taqdeer refer to divine decree - Allah's predetermined plan for all creation.",
    "explanationUrdu":
        "قدر اور تقدیر دونوں سے مراد الہی فیصلہ ہے - اللہ کا تمام مخلوقات کے لئے پہلے سے طے شدہ منصوبہ۔"
  },
  {
    "question": "Which prophet was known for his beautiful patience?",
    "questionUrdu": "کون سا نبی اپنی خوبصورت صبر کے لئے مشہور تھا؟",
    "options": ["Ayyub (AS)", "Yaqub (AS)", "Yusuf (AS)", "Zakariya (AS)"],
    "optionsUrdu": [
      "ایوب (علیہ السلام)",
      "یعقوب (علیہ السلام)",
      "یوسف (علیہ السلام)",
      "زکریا (علیہ السلام)"
    ],
    "correctAnswer": "Ayyub (AS)",
    "correctAnswerUrdu": "ایوب (علیہ السلام)",
    "explanation":
        "Prophet Ayyub (Job) is most famous for his \"Sabr Jameel\" (beautiful patience) during severe trials and suffering.",
    "explanationUrdu":
        "نبی ایوب (علیہ السلام) اپنے \"صبر جمیل\" (خوبصورت صبر) کے لئے سب سے زیادہ مشہور ہیں جو شدید آزمائشوں اور تکلیفوں کے دوران دکھائی دیا۔"
  },
  {
    "question": "What is the name of the bridge that leads to paradise?",
    "questionUrdu": "جنت کی طرف جانے والے پل کا نام کیا ہے؟",
    "options": ["Sirat", "Mizan", "Hawd", "Maqam"],
    "optionsUrdu": ["صراط", "میزان", "حوض", "مقام"],
    "correctAnswer": "Sirat",
    "correctAnswerUrdu": "صراط",
    "explanation":
        "As-Sirat is the bridge over hell that leads to paradise, which all souls must cross on Judgment Day.",
    "explanationUrdu":
        "صراط وہ پل ہے جو جہنم کے اوپر سے جنت کی طرف جاتا ہے، جسے قیامت کے دن تمام روحوں کو عبور کرنا ہوگا۔"
  },
  {
    "question": "Which companion was known for his knowledge of the Quran?",
    "questionUrdu": "کون سا صحابی قرآن کے علم کے لئے مشہور تھا؟",
    "options": ["Abu Bakr (RA)", "Umar (RA)", "Uthman (RA)", "Ibn Mas'ud (RA)"],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "عمر (رضی اللہ عنہ)",
      "عثمان (رضی اللہ عنہ)",
      "ابن مسعود (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Ibn Mas'ud (RA)",
    "correctAnswerUrdu": "ابن مسعود (رضی اللہ عنہ)",
    "explanation":
        "Abdullah ibn Mas'ud (RA) was one of the first to memorize the Quran and was known for his deep knowledge of it.",
    "explanationUrdu":
        "عبداللہ بن مسعود (رضی اللہ عنہ) سب سے پہلے قرآن حفظ کرنے والوں میں سے ایک تھے اور اس کے گہرے علم کے لئے مشہور تھے۔"
  },
  {
    "question": "What is the Islamic term for the soul?",
    "questionUrdu": "روح کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Ruh", "Nafs", "Qalb", "Aql"],
    "optionsUrdu": ["روح", "نفس", "قلب", "عقل"],
    "correctAnswer": "Ruh",
    "correctAnswerUrdu": "روح",
    "explanation":
        "Ruh is the Arabic term for the soul - the spiritual essence that Allah breathed into Adam (AS).",
    "explanationUrdu":
        "روح روح کے لئے عربی اصطلاح ہے - وہ روحانی جوہر جو اللہ نے آدم (علیہ السلام) میں پھونکا۔"
  },
  {
    "question": "Which prophet was saved from the fire of his enemies?",
    "questionUrdu": "کون سا نبی اپنے دشمنوں کی آگ سے بچایا گیا؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Isa (AS)", "Lut (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "لوط (علیہ السلام)"
    ],
    "correctAnswer": "Ibrahim (AS)",
    "correctAnswerUrdu": "ابراہیم (علیہ السلام)",
    "explanation":
        "Prophet Ibrahim (AS) was thrown into a fire by King Nimrod, but Allah made the fire cool and safe for him.",
    "explanationUrdu":
        "نبی ابراہیم (علیہ السلام) کو بادشاہ نمرود نے آگ میں پھینکا، لیکن اللہ نے آگ کو ان کے لئے ٹھنڈی اور محفوظ بنا دیا۔"
  },
  {
    "question":
        "What is the name of the Prophet's (PBUH) horse during the Night Journey?",
    "questionUrdu":
        "شب معراج کے دوران نبی صلی اللہ علیہ وسلم کے گھوڑے کا نام کیا تھا؟",
    "options": ["Buraq", "Duldul", "Qaswa", "Adba"],
    "optionsUrdu": ["بروق", "دلدل", "قصواء", "عضباء"],
    "correctAnswer": "Buraq",
    "correctAnswerUrdu": "بروق",
    "explanation":
        "Buraq was the heavenly steed that carried Prophet Muhammad (PBUH) during the Night Journey (Isra and Miraj).",
    "explanationUrdu":
        "بروق وہ آسمانی سواری تھی جس نے شب معراج (اسراء اور معراج) کے دوران نبی محمد صلی اللہ علیہ وسلم کو لے کر گئی۔"
  },
  {
    "question": "Which Surah mentions the story of the People of the Elephant?",
    "questionUrdu": "کون سی سورہ ہاتھی والوں کی کہانی کا ذکر کرتی ہے؟",
    "options": ["Al-Fil", "Quraish", "Al-Masad", "Al-Humazah"],
    "optionsUrdu": ["الفیل", "قریش", "المسد", "الهمزہ"],
    "correctAnswer": "Al-Fil",
    "correctAnswerUrdu": "الفیل",
    "explanation":
        "Surah Al-Fil tells the story of Abraha's army with elephants that tried to destroy the Kaaba but were defeated by Allah.",
    "explanationUrdu":
        "سورہ الفیل ابراہہ کی فوج کی کہانی سناتی ہے جو ہاتھیوں کے ساتھ کعبہ کو تباہ کرنے کی کوشش کی لیکن اللہ نے انہیں شکست دی۔"
  },
  {
    "question": "What is the Arabic word for mosque?",
    "questionUrdu": "مسجد کے لئے عربی لفظ کیا ہے؟",
    "options": ["Masjid", "Jami", "Musalla", "All of the above"],
    "optionsUrdu": ["مسجد", "جامع", "مصلیٰ", "مذکورہ بالا سب"],
    "correctAnswer": "All of the above",
    "correctAnswerUrdu": "مذکورہ بالا سب",
    "explanation":
        "Mosque can be called Masjid (place of prostration), Jami (congregational mosque), or Musalla (place of prayer).",
    "explanationUrdu":
        "مسجد کو مسجد (سجدہ کی جگہ)، جامع (اجتماعی مسجد)، یا مصلیٰ (نماز کی جگہ) کہا جا سکتا ہے۔"
  },
  {
    "question": "Which prophet was given the miracle of splitting the moon?",
    "questionUrdu": "کون سے نبی کو چاند پھاڑنے کا معجزہ دیا گیا؟",
    "options": ["Muhammad (PBUH)", "Musa (AS)", "Isa (AS)", "Ibrahim (AS)"],
    "optionsUrdu": [
      "محمد صلی اللہ علیہ وسلم",
      "موسیٰ (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "ابراہیم (علیہ السلام)"
    ],
    "correctAnswer": "Muhammad (PBUH)",
    "correctAnswerUrdu": "محمد صلی اللہ علیہ وسلم",
    "explanation":
        "The splitting of the moon was a miracle given to Prophet Muhammad (PBUH) as a sign to the unbelievers of Mecca.",
    "explanationUrdu":
        "چاند کا پھٹنا نبی محمد صلی اللہ علیہ وسلم کو مکہ کے کافروں کے لئے ایک نشانی کے طور پر دیا گیا معجزہ تھا۔"
  },
  {
    "question": "What is the Islamic term for the inner dimension of faith?",
    "questionUrdu": "ایمان کے اندرونی پہلو کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Islam", "Iman", "Ihsan", "Taqwa"],
    "optionsUrdu": ["اسلام", "ایمان", "احسان", "تقویٰ"],
    "correctAnswer": "Ihsan",
    "correctAnswerUrdu": "احسان",
    "explanation":
        "Ihsan is the highest level of faith - worshipping Allah as if you see Him, and knowing that He sees you.",
    "explanationUrdu":
        "احسان ایمان کا سب سے بلند درجہ ہے - اللہ کی عبادت اس طرح کرنا جیسے آپ اسے دیکھ رہے ہوں، اور یہ جانتے ہوئے کہ وہ آپ کو دیکھ رہا ہے۔"
  },
  {
    "question": "Which prophet was given a staff that turned into a serpent?",
    "questionUrdu": "کون سے نبی کو ایک عصا دیا گیا جو سانپ میں تبدیل ہو گیا؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Harun (AS)", "Sulaiman (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "ہارون (علیہ السلام)",
      "سلیمان (علیہ السلام)"
    ],
    "correctAnswer": "Musa (AS)",
    "correctAnswerUrdu": "موسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Musa (Moses) was given a staff that would turn into a serpent as one of his miracles to show Pharaoh.",
    "explanationUrdu":
        "نبی موسیٰ (علیہ السلام) کو ایک عصا دیا گیا جو فرعون کو دکھانے کے لئے ان کے معجزوں میں سے ایک کے طور پر سانپ میں تبدیل ہو جاتا تھا۔"
  },
  {
    "question":
        "What is the name of the special charity given during Eid al-Fitr?",
    "questionUrdu":
        "عید الفطر کے دوران دی جانے والی خصوصی خیرات کا نام کیا ہے؟",
    "options": ["Zakat", "Sadaqah", "Zakat al-Fitr", "Khairat"],
    "optionsUrdu": ["زکوٰۃ", "صدقہ", "زکوٰۃ الفطر", "خیرات"],
    "correctAnswer": "Zakat al-Fitr",
    "correctAnswerUrdu": "زکوٰۃ الفطر",
    "explanation":
        "Zakat al-Fitr is the special charity given before Eid al-Fitr prayer to purify the fast and help the needy celebrate.",
    "explanationUrdu":
        "زکوٰۃ الفطر وہ خصوصی خیرات ہے جو عید الفطر کی نماز سے پہلے دی جاتی ہے تاکہ روزہ پاک ہو اور ضرورت مند عید منا سکیں۔"
  },
  {
    "question": "Which companion was the first child to accept Islam?",
    "questionUrdu": "کون سا صحابی سب سے پہلے بچہ تھا جس نے اسلام قبول کیا؟",
    "options": [
      "Ali (RA)",
      "Abdullah ibn Abbas (RA)",
      "Anas ibn Malik (RA)",
      "Usama ibn Zaid (RA)"
    ],
    "optionsUrdu": [
      "علی (رضی اللہ عنہ)",
      "عبداللہ بن عباس (رضی اللہ عنہ)",
      "انس بن مالک (رضی اللہ عنہ)",
      "اسامہ بن زید (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Ali (RA)",
    "correctAnswerUrdu": "علی (رضی اللہ عنہ)",
    "explanation":
        "Ali ibn Abi Talib (RA) was the first child to accept Islam when he was about 10 years old.",
    "explanationUrdu":
        "علی بن ابی طالب (رضی اللہ عنہ) وہ پہلے بچہ تھے جنہوں نے تقریباً 10 سال کی عمر میں اسلام قبول کیا۔"
  },
  {
    "question": "What is the Islamic term for the five daily prayers?",
    "questionUrdu": "پانچ روزانہ نمازوں کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Salawat", "Salat al-Khams", "As-Salawat al-Khams", "Fara'id"],
    "optionsUrdu": ["صلوات", "صلاة الخمس", "الصلوات الخمس", "فرائض"],
    "correctAnswer": "As-Salawat al-Khams",
    "correctAnswerUrdu": "الصلوات الخمس",
    "explanation":
        "As-Salawat al-Khams means \"the five prayers\" referring to the five daily obligatory prayers in Islam.",
    "explanationUrdu":
        "الصلوات الخمس کا مطلب ہے \"پانچ نمازیں\" جو اسلام میں پانچ روزانہ واجب نمازوں کی طرف اشارہ کرتی ہیں۔"
  },
  {
    "question":
        "Which prophet was given the miracle of bringing clay birds to life?",
    "questionUrdu":
        "کون سے نبی کو مٹی کے پرندوں کو زندہ کرنے کا معجزہ دیا گیا؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Isa (AS)", "Sulaiman (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "سلیمان (علیہ السلام)"
    ],
    "correctAnswer": "Isa (AS)",
    "correctAnswerUrdu": "عیسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Isa (Jesus) was given the miracle to breathe life into clay birds as a sign of his prophethood.",
    "explanationUrdu":
        "نبی عیسیٰ (علیہ السلام) کو ان کی نبوت کے نشان کے طور پر مٹی کے پرندوں میں جان ڈالنے کا معجزہ دیا گیا۔"
  },
  {
    "question": "What is the name of the special prayer for seeking guidance?",
    "questionUrdu": "رہنمائی مانگنے کے لئے خصوصی نماز کا نام کیا ہے؟",
    "options": [
      "Salat al-Istikharah",
      "Salat al-Hajah",
      "Salat al-Tawbah",
      "Salat al-Shukr"
    ],
    "optionsUrdu": [
      "صلاة الاستخارہ",
      "صلاة الحاجہ",
      "صلاة التوبہ",
      "صلاة الشکر"
    ],
    "correctAnswer": "Salat al-Istikharah",
    "correctAnswerUrdu": "صلاة الاستخارہ",
    "explanation":
        "Salat al-Istikharah is the prayer for seeking Allah's guidance when making important decisions.",
    "explanationUrdu":
        "صلاة الاستخارہ وہ نماز ہے جو اہم فیصلے کرنے کے وقت اللہ کی رہنمائی مانگنے کے لئے ادا کی جاتی ہے۔"
  },
  {
    "question": "Which prophet was known as \"Dhul-Kifl\"?",
    "questionUrdu": "کون سا نبی \"ذوالکفل\" کے نام سے مشہور تھا؟",
    "options": [
      "Ayyub (AS)",
      "Yunus (AS)",
      "Idris (AS)",
      "The identity is debated among scholars"
    ],
    "optionsUrdu": [
      "ایوب (علیہ السلام)",
      "یونس (علیہ السلام)",
      "ادریس (علیہ السلام)",
      "علماء میں اس کی شناخت پر بحث ہے"
    ],
    "correctAnswer": "The identity is debated among scholars",
    "correctAnswerUrdu": "علماء میں اس کی شناخت پر بحث ہے",
    "explanation":
        "Dhul-Kifl is mentioned in the Quran, but scholars differ on whether he was a prophet or a righteous man, and his exact identity.",
    "explanationUrdu":
        "ذوالکفل کا ذکر قرآن میں ہے، لیکن علماء اس بات پر اختلاف رکھتے ہیں کہ آیا وہ نبی تھے یا نیک آدمی، اور ان کی صحیح شناخت پر۔"
  },
  {
    "question": "What is the Arabic term for the Day of Judgment?",
    "questionUrdu": "قیامت کے دن کے لئے عربی اصطلاح کیا ہے؟",
    "options": [
      "Yawm al-Qiyamah",
      "Yawm al-Din",
      "Yawm al-Hisab",
      "All of the above"
    ],
    "optionsUrdu": ["یوم القیامہ", "یوم الدین", "یوم الحساب", "مذکورہ بالا سب"],
    "correctAnswer": "All of the above",
    "correctAnswerUrdu": "مذکورہ بالا سب",
    "explanation":
        "The Day of Judgment has many names: Yawm al-Qiyamah (Day of Resurrection), Yawm al-Din (Day of Religion), Yawm al-Hisab (Day of Reckoning).",
    "explanationUrdu":
        "قیامت کے دن کے کئی نام ہیں: یوم القیامہ (قیامت کا دن)، یوم الدین (مذہب کا دن)، یوم الحساب (حساب کا دن)۔"
  },
  {
    "question":
        "Which prophet was given the miracle of healing with his saliva?",
    "questionUrdu": "کون سے نبی کو اپنے لعاب سے شفا دینے کا معجزہ دیا گیا؟",
    "options": ["Muhammad (PBUH)", "Isa (AS)", "Musa (AS)", "Sulaiman (AS)"],
    "optionsUrdu": [
      "محمد صلی اللہ علیہ وسلم",
      "عیسیٰ (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "سلیمان (علیہ السلام)"
    ],
    "correctAnswer": "Muhammad (PBUH)",
    "correctAnswerUrdu": "محمد صلی اللہ علیہ وسلم",
    "explanation":
        "Prophet Muhammad (PBUH) had the blessed ability to heal wounds and ailments with his saliva, as recorded in authentic hadiths.",
    "explanationUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کو اپنے لعاب سے زخموں اور بیماریوں کو شفا دینے کی مبارک صلاحیت دی گئی تھی، جیسا کہ مستند احادیث میں درج ہے۔"
  },
  {
    "question":
        "What is the name of the valley where Hajar ran between two hills?",
    "questionUrdu":
        "اس وادی کا نام کیا ہے جہاں ہاجرہ دو پہاڑیوں کے درمیان دوڑیں؟",
    "options": [
      "Valley of Safa and Marwah",
      "Valley of Mina",
      "Valley of Arafat",
      "Valley of Muzdalifah"
    ],
    "optionsUrdu": [
      "وادی صفا و مروہ",
      "وادی منیٰ",
      "وادی عرفات",
      "وادی مزدلفہ"
    ],
    "correctAnswer": "Valley of Safa and Marwah",
    "correctAnswerUrdu": "وادی صفا و مروہ",
    "explanation":
        "Hajar ran between the hills of Safa and Marwah searching for water for her son Ismail (AS), which is now part of Hajj rituals.",
    "explanationUrdu":
        "ہاجرہ اپنے بیٹے اسماعیل (علیہ السلام) کے لئے پانی کی تلاش میں صفا اور مروہ کی پہاڑیوں کے درمیان دوڑیں، جو اب حج کے مناسک کا حصہ ہے۔"
  },
  {
    "question": "Which companion was known as \"The Sword of Allah\"?",
    "questionUrdu": "کون سا صحابی \"اللہ کی تلوار\" کے نام سے مشہور تھا؟",
    "options": [
      "Ali (RA)",
      "Khalid ibn Walid (RA)",
      "Sa'd ibn Abi Waqqas (RA)",
      "Amr ibn al-As (RA)"
    ],
    "optionsUrdu": [
      "علی (رضی اللہ عنہ)",
      "خالد بن ولید (رضی اللہ عنہ)",
      "سعد بن ابی وقاص (رضی اللہ عنہ)",
      "عمر بن العاص (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Khalid ibn Walid (RA)",
    "correctAnswerUrdu": "خالد بن ولید (رضی اللہ عنہ)",
    "explanation":
        "Khalid ibn Walid (RA) was given the title \"Saif Allah al-Maslul\" (The Drawn Sword of Allah) by Prophet Muhammad (PBUH).",
    "explanationUrdu":
        "خالد بن ولید (رضی اللہ عنہ) کو نبی محمد صلی اللہ علیہ وسلم نے \"سیف اللہ المسلول\" (اللہ کی کھینچی ہوئی تلوار) کا لقب دیا۔"
  },
  {
    "question": "What is the Islamic term for the prayer niche in a mosque?",
    "questionUrdu": "مسجد میں نماز کی جگہ کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Minbar", "Mihrab", "Minaret", "Qibla"],
    "optionsUrdu": ["منبر", "محراب", "مینار", "قبلہ"],
    "correctAnswer": "Mihrab",
    "correctAnswerUrdu": "محراب",
    "explanation":
        "Mihrab is the semicircular niche in a mosque wall that indicates the direction of Mecca (Qibla) for prayer.",
    "explanationUrdu":
        "محراب مسجد کی دیوار میں نیم دائرہ نما جگہ ہے جو نماز کے لئے مکہ (قبلہ) کی سمت کی نشاندہی کرتی ہے۔"
  },
  {
    "question":
        "Which prophet was granted the miracle of an ever-flowing spring?",
    "questionUrdu": "کون سے نبی کو ہمیشہ بہنے والے چشمے کا معجزہ دیا گیا؟",
    "options": [
      "Musa (AS)",
      "Isa (AS)",
      "Multiple prophets had this miracle",
      "Khidr (AS)"
    ],
    "optionsUrdu": [
      "موسیٰ (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "کئی انبیاء کو یہ معجزہ دیا گیا",
      "خضر (علیہ السلام)"
    ],
    "correctAnswer": "Multiple prophets had this miracle",
    "correctAnswerUrdu": "کئی انبیاء کو یہ معجزہ دیا گیا",
    "explanation":
        "Several prophets were granted water miracles: Musa (AS) struck a rock for water, and the well of Zamzam appeared for Ismail (AS).",
    "explanationUrdu":
        "کئی انبیاء کو پانی کے معجزات دیے گئے: موسیٰ (علیہ السلام) نے پتھر پر ضرب لگائی تو پانی نکلا، اور اسماعیل (علیہ السلام) کے لئے زمزم کا کنواں ظاہر ہوا۔"
  },
  {
    "question": "What is the name of the special prayer performed before dawn?",
    "questionUrdu": "فجر سے پہلے ادا کی جانے والی خصوصی نماز کا نام کیا ہے؟",
    "options": ["Tahajjud", "Fajr", "Witr", "Sunnah"],
    "optionsUrdu": ["تہجد", "فجر", "وتر", "سنت"],
    "correctAnswer": "Tahajjud",
    "correctAnswerUrdu": "تہجد",
    "explanation":
        "Tahajjud is the voluntary night prayer performed in the last third of the night before Fajr prayer.",
    "explanationUrdu":
        "تہجد رات کی رضا کارانہ نماز ہے جو فجر کی نماز سے پہلے رات کے آخری تہائی حصے میں ادا کی جاتی ہے۔"
  },
  {
    "question": "Which prophet was given the miracle of controlling iron?",
    "questionUrdu": "کون سے نبی کو لوہے پر قابو پانے کا معجزہ دیا گیا؟",
    "options": [
      "Sulaiman (AS)",
      "Dawud (AS)",
      "Ibrahim (AS)",
      "Dhul-Qarnayn (AS)"
    ],
    "optionsUrdu": [
      "سلیمان (علیہ السلام)",
      "داوود (علیہ السلام)",
      "ابراہیم (علیہ السلام)",
      "ذوالقرنین (علیہ السلام)"
    ],
    "correctAnswer": "Dawud (AS)",
    "correctAnswerUrdu": "داوود (علیہ السلام)",
    "explanation":
        "Prophet Dawud (David) was given the miracle that iron would become soft in his hands like clay for making armor.",
    "explanationUrdu":
        "نبی داوود (علیہ السلام) کو یہ معجزہ دیا گیا کہ لوہا ان کے ہاتھوں میں مٹی کی طرح نرم ہو جاتا تھا تاکہ وہ زرہ بنائیں۔"
  },
  {
    "question": "What is the Islamic term for the pulpit in a mosque?",
    "questionUrdu": "مسجد میں منبر کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Mihrab", "Minbar", "Minaret", "Dikka"],
    "optionsUrdu": ["محراب", "منبر", "مینار", "دکہ"],
    "correctAnswer": "Minbar",
    "correctAnswerUrdu": "منبر",
    "explanation":
        "Minbar is the raised platform or pulpit in a mosque from which the Imam delivers sermons (Khutbah).",
    "explanationUrdu":
        "منبر مسجد میں بلند پلیٹ فارم یا منبر ہے جہاں سے امام خطبہ دیتا ہے۔"
  },
  {
    "question": "Which prophet was saved from a pit by a caravan?",
    "questionUrdu": "کون سا نبی ایک گڑھے سے قافلے کے ذریعے بچایا گیا؟",
    "options": ["Yusuf (AS)", "Yaqub (AS)", "Ishaq (AS)", "Ismail (AS)"],
    "optionsUrdu": [
      "یوسف (علیہ السلام)",
      "یعقوب (علیہ السلام)",
      "اسحاق (علیہ السلام)",
      "اسماعیل (علیہ السلام)"
    ],
    "correctAnswer": "Yusuf (AS)",
    "correctAnswerUrdu": "یوسف (علیہ السلام)",
    "explanation":
        "Prophet Yusuf (Joseph) was thrown into a well by his brothers and later rescued by a passing caravan.",
    "explanationUrdu":
        "نبی یوسف (علیہ السلام) کو ان کے بھائیوں نے کنویں میں پھینک دیا تھا اور بعد میں ایک گزرتے قافلے نے انہیں بچایا۔"
  },
  {
    "question": "What is the name of the second call to prayer?",
    "questionUrdu": "نماز کے لئے دوسری پکار کا نام کیا ہے؟",
    "options": ["Adhan", "Iqama", "Takbir", "Taslim"],
    "optionsUrdu": ["اذان", "اقامہ", "تکبیر", "تسلیم"],
    "correctAnswer": "Iqama",
    "correctAnswerUrdu": "اقامہ",
    "explanation":
        "Iqama is the second call to prayer recited just before the congregational prayer begins.",
    "explanationUrdu":
        "اقامہ نماز کے لئے دوسری پکار ہے جو جماعت کی نماز شروع ہونے سے بالکل پہلے پڑھی جاتی ہے۔"
  },
  {
    "question": "Which angel will separate the good from evil on Judgment Day?",
    "questionUrdu": "قیامت کے دن نیک اور بد کو کون سا فرشتہ الگ کرے گا؟",
    "options": [
      "Jibreel (AS)",
      "Mikail (AS)",
      "Israfil (AS)",
      "Angels collectively"
    ],
    "optionsUrdu": [
      "جبریل (علیہ السلام)",
      "میکائیل (علیہ السلام)",
      "اسرافیل (علیہ السلام)",
      "فرشتوں کا مجموعہ"
    ],
    "correctAnswer": "Angels collectively",
    "correctAnswerUrdu": "فرشتوں کا مجموعہ",
    "explanation":
        "On Judgment Day, angels collectively will be involved in separating people based on their deeds, not one specific angel.",
    "explanationUrdu":
        "قیامت کے دن، فرشتوں کا مجموعہ لوگوں کو ان کے اعمال کی بنیاد پر الگ کرنے میں شامل ہوگا، نہ کہ کوئی خاص فرشتہ۔"
  },
  {
    "question":
        "What is the Islamic term for the intermediate realm between death and resurrection?",
    "questionUrdu":
        "موت اور قیامت کے درمیان کے عالم کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Akhirah", "Dunya", "Barzakh", "Qiyamah"],
    "optionsUrdu": ["آخرت", "دنیا", "برزخ", "قیامہ"],
    "correctAnswer": "Barzakh",
    "correctAnswerUrdu": "برزخ",
    "explanation":
        "Barzakh is the intermediate state or barrier between the life of this world and the afterlife.",
    "explanationUrdu":
        "برزخ اس دنیا کی زندگی اور آخرت کے درمیان کا درمیانی عالم یا رکاوٹ ہے۔"
  },
  {
    "question": "Which prophet was given a she-camel as a miracle?",
    "questionUrdu": "کون سے نبی کو معجزے کے طور پر اونٹنی دی گئی؟",
    "options": ["Hud (AS)", "Salih (AS)", "Shu'aib (AS)", "Lut (AS)"],
    "optionsUrdu": [
      "ہود (علیہ السلام)",
      "صالح (علیہ السلام)",
      "شعیب (علیہ السلام)",
      "لوط (علیہ السلام)"
    ],
    "correctAnswer": "Salih (AS)",
    "correctAnswerUrdu": "صالح (علیہ السلام)",
    "explanation":
        "Prophet Salih (AS) was given a miraculous she-camel as a sign to his people, the Thamud tribe.",
    "explanationUrdu":
        "نبی صالح (علیہ السلام) کو ان کی قوم، قبیلہ ثمود کے لئے ایک معجزاتی اونٹنی بطور نشان دی گئی۔"
  },
  {
    "question":
        "What is the reward for someone who memorizes the entire Quran?",
    "questionUrdu": "پورے قرآن کو حفظ کرنے والے کے لئے کیا اجر ہے؟",
    "options": [
      "Special place in Paradise",
      "Crown for their parents",
      "Higher status on Judgment Day",
      "All of the above"
    ],
    "optionsUrdu": [
      "جنت میں خاص مقام",
      "والدین کے لئے تاج",
      "قیامت کے دن بلند مرتبہ",
      "مذکورہ بالا سب"
    ],
    "correctAnswer": "All of the above",
    "correctAnswerUrdu": "مذکورہ بالا سب",
    "explanation":
        "Those who memorize the Quran (Huffaz) receive multiple rewards: special status in Paradise, crowns for their parents, and higher ranks on Judgment Day.",
    "explanationUrdu":
        "جو لوگ قرآن حفظ کرتے ہیں (حفاظ) انہیں کئی انعامات ملتے ہیں: جنت میں خاص مقام، ان کے والدین کے لئے تاج، اور قیامت کے دن بلند درجات۔"
  },
  {
    "question":
        "Which companion was known for his beautiful recitation of the Quran?",
    "questionUrdu": "کون سا صحابی قرآن کی خوبصورت تلاوت کے لئے مشہور تھا؟",
    "options": [
      "Abu Bakr (RA)",
      "Abu Musa al-Ash'ari (RA)",
      "Ibn Mas'ud (RA)",
      "Ubayy ibn Ka'b (RA)"
    ],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "ابو موسیٰ الاشعری (رضی اللہ عنہ)",
      "ابن مسعود (رضی اللہ عنہ)",
      "ابی بن کعب (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Abu Musa al-Ash'ari (RA)",
    "correctAnswerUrdu": "ابو موسیٰ الاشعری (رضی اللہ عنہ)",
    "explanation":
        "Abu Musa al-Ash'ari (RA) was praised by Prophet Muhammad (PBUH) for his beautiful voice in reciting the Quran.",
    "explanationUrdu":
        "ابو موسیٰ الاشعری (رضی اللہ عنہ) کی قرآن کی تلاوت کی خوبصورت آواز کے لئے نبی محمد صلی اللہ علیہ وسلم نے تعریف کی۔"
  },
  {
    "question":
        "What is the name of the gate of Paradise reserved for those who fast?",
    "questionUrdu":
        "جنت کا وہ دروازہ جو روزہ رکھنے والوں کے لئے مختص ہے اس کا نام کیا ہے؟",
    "options": [
      "Baab ar-Rayyan",
      "Baab as-Salah",
      "Baab az-Zakat",
      "Baab al-Hajj"
    ],
    "optionsUrdu": ["باب الریان", "باب الصلاۃ", "باب الزکوٰۃ", "باب الحج"],
    "correctAnswer": "Baab ar-Rayyan",
    "correctAnswerUrdu": "باب الریان",
    "explanation":
        "Baab ar-Rayyan is the special gate of Paradise through which only those who regularly fasted will enter.",
    "explanationUrdu":
        "باب الریان جنت کا وہ خاص دروازہ ہے جس سے صرف وہ لوگ داخل ہوں گے جو باقاعدگی سے روزہ رکھتے تھے۔"
  },
  {
    "question": "What is the Arabic word for fasting?",
    "questionUrdu": "روزہ کے لئے عربی لفظ کیا ہے؟",
    "options": ["Salah", "Zakat", "Sawm", "Hajj"],
    "optionsUrdu": ["صلاة", "زکوٰۃ", "صوم", "حج"],
    "correctAnswer": "Sawm",
    "correctAnswerUrdu": "صوم",
    "explanation":
        "Sawm is the Arabic word for fasting, which means abstaining from food, drink, and other physical needs during daylight hours.",
    "explanationUrdu":
        "صوم روزہ کے لئے عربی لفظ ہے، جس کا مطلب ہے دن کی روشنی کے اوقات میں کھانے، پینے اور دیگر جسمانی ضروریات سے پرہیز کرنا۔"
  },
  {
    "question":
        "Which prophet was known as \"Sayyid al-Anbiya\" (Master of Prophets)?",
    "questionUrdu":
        "کون سا نبی \"سید الانبیاء\" (انبیاء کا سردار) کے نام سے مشہور تھا؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Isa (AS)", "Muhammad (PBUH)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "محمد صلی اللہ علیہ وسلم"
    ],
    "correctAnswer": "Muhammad (PBUH)",
    "correctAnswerUrdu": "محمد صلی اللہ علیہ وسلم",
    "explanation":
        "Prophet Muhammad (PBUH) is called \"Sayyid al-Anbiya\" meaning the Master or Leader of all Prophets.",
    "explanationUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کو \"سید الانبیاء\" کہا جاتا ہے جس کا مطلب ہے تمام انبیاء کا سردار یا رہنما۔"
  },
  {
    "question":
        "What is the name of the tree mentioned in the Quran that grows in hell?",
    "questionUrdu":
        "قرآن میں ذکر کردہ اس درخت کا نام کیا ہے جو جہنم میں اگتا ہے؟",
    "options": ["Zaqqum", "Sidrah", "Tuba", "Gharkad"],
    "optionsUrdu": ["زقوم", "سدرہ", "طوبیٰ", "غرقد"],
    "correctAnswer": "Zaqqum",
    "correctAnswerUrdu": "زقوم",
    "explanation":
        "Zaqqum is the cursed tree that grows in hell, mentioned in the Quran as food for the people of hellfire.",
    "explanationUrdu":
        "زقوم وہ ملعون درخت ہے جو جہنم میں اگتا ہے، جو قرآن میں جہنم کے لوگوں کے کھانے کے طور پر ذکر کیا گیا ہے۔"
  },
  {
    "question":
        "Which companion was known as \"The Mother of Believers\" and was very young when she married the Prophet?",
    "questionUrdu":
        "کون سی صحابیہ \"ام المؤمنین\" کے نام سے مشہور تھی اور نبی سے شادی کے وقت بہت کم عمر تھی؟",
    "options": ["Khadijah (RA)", "Aisha (RA)", "Hafsa (RA)", "Sawdah (RA)"],
    "optionsUrdu": [
      "خدیجہ (رضی اللہ عنہا)",
      "عائشہ (رضی اللہ عنہا)",
      "حفصہ (رضی اللہ عنہا)",
      "سودہ (رضی اللہ عنہا)"
    ],
    "correctAnswer": "Aisha (RA)",
    "correctAnswerUrdu": "عائشہ (رضی اللہ عنہا)",
    "explanation":
        "Aisha bint Abu Bakr (RA) was the youngest wife of Prophet Muhammad (PBUH) and is called \"Mother of the Believers.\"",
    "explanationUrdu":
        "عائشہ بنت ابو بکر (رضی اللہ عنہا) نبی محمد صلی اللہ علیہ وسلم کی سب سے کم عمر بیوی تھیں اور انہیں \"ام المؤمنین\" کہا جاتا ہے۔"
  },
  {
    "question": "What is the Islamic term for the love of this world?",
    "questionUrdu": "اس دنیا کی محبت کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Hubb ad-Dunya", "Hubb al-Akhirah", "Taqwa", "Zuhd"],
    "optionsUrdu": ["حب الدنیا", "حب الآخرۃ", "تقویٰ", "زہد"],
    "correctAnswer": "Hubb ad-Dunya",
    "correctAnswerUrdu": "حب الدنیا",
    "explanation":
        "Hubb ad-Dunya means love of the worldly life, which Islam teaches should be balanced with love for the afterlife.",
    "explanationUrdu":
        "حب الدنیا کا مطلب ہے دنیاوی زندگی کی محبت، جسے اسلام سکھاتا ہے کہ اسے آخرت کی محبت کے ساتھ متوازن رکھنا چاہئے۔"
  },
  {
    "question": "Which prophet was given the miracle of making the dead speak?",
    "questionUrdu": "کون سے نبی کو مردوں کو بولنے کا معجزہ دیا گیا؟",
    "options": ["Isa (AS)", "Musa (AS)", "Sulaiman (AS)", "Muhammad (PBUH)"],
    "optionsUrdu": [
      "عیسیٰ (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "سلیمان (علیہ السلام)",
      "محمد صلی اللہ علیہ وسلم"
    ],
    "correctAnswer": "Isa (AS)",
    "correctAnswerUrdu": "عیسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Isa (Jesus) was given the miracle to make the dead speak and tell about their affairs in the grave.",
    "explanationUrdu":
        "نبی عیسیٰ (علیہ السلام) کو مردوں کو بولنے اور ان کے قبر میں حالات بتانے کا معجزہ دیا گیا۔"
  },
  {
    "question": "What is the name of the special prayer performed for rain?",
    "questionUrdu": "بارش کے لئے ادا کی جانے والی خصوصی نماز کا نام کیا ہے؟",
    "options": [
      "Salat al-Kusuf",
      "Salat al-Istisqa",
      "Salat al-Istikharah",
      "Salat al-Hajah"
    ],
    "optionsUrdu": [
      "صلاة الکسوف",
      "صلاة الاستسقاء",
      "صلاة الاستخارہ",
      "صلاة الحاجہ"
    ],
    "correctAnswer": "Salat al-Istisqa",
    "correctAnswerUrdu": "صلاة الاستسقاء",
    "explanation":
        "Salat al-Istisqa is the special prayer performed during times of drought to ask Allah for rain.",
    "explanationUrdu":
        "صلاة الاستسقاء وہ خصوصی نماز ہے جو خشک سالی کے اوقات میں اللہ سے بارش مانگنے کے لئے ادا کی جاتی ہے۔"
  },
  {
    "question": "Which prophet was thrown into prison for interpreting dreams?",
    "questionUrdu": "کون سا نبی خوابوں کی تعبیر کرنے کے لئے جیل میں ڈالا گیا؟",
    "options": ["Yusuf (AS)", "Daniel (AS)", "Yaqub (AS)", "Ibrahim (AS)"],
    "optionsUrdu": [
      "یوسف (علیہ السلام)",
      "دانیال (علیہ السلام)",
      "یعقوب (علیہ السلام)",
      "ابراہیم (علیہ السلام)"
    ],
    "correctAnswer": "Yusuf (AS)",
    "correctAnswerUrdu": "یوسف (علیہ السلام)",
    "explanation":
        "Prophet Yusuf (Joseph) was imprisoned in Egypt but became famous there for interpreting dreams accurately.",
    "explanationUrdu":
        "نبی یوسف (علیہ السلام) کو مصر میں قید کیا گیا لیکن وہاں خوابوں کی درست تعبیر کرنے کے لئے مشہور ہوئے۔"
  },
  {
    "question": "What is the Arabic term for the Day of Resurrection?",
    "questionUrdu": "قیامت کے دن کے لئے عربی اصطلاح کیا ہے؟",
    "options": [
      "Yawm al-Qiyamah",
      "Yawm al-Ba'th",
      "Yawm al-Nushur",
      "All of the above"
    ],
    "optionsUrdu": ["یوم القیامہ", "یوم البعث", "یوم النشور", "مذکورہ بالا سب"],
    "correctAnswer": "All of the above",
    "correctAnswerUrdu": "مذکورہ بالا سب",
    "explanation":
        "The Day of Resurrection has multiple names: Yawm al-Qiyamah, Yawm al-Ba'th (Day of Rising), and Yawm al-Nushur (Day of Emergence).",
    "explanationUrdu":
        "قیامت کے دن کے کئی نام ہیں: یوم القیامہ، یوم البعث (اٹھنے کا دن)، اور یوم النشور (ابھرنے کا دن)۔"
  },
  {
    "question": "Which angel records the good deeds?",
    "questionUrdu": "کون سا فرشتہ نیک اعمال کو لکھتا ہے؟",
    "options": [
      "The angel on the right shoulder",
      "The angel on the left shoulder",
      "Both angels",
      "Jibreel (AS)"
    ],
    "optionsUrdu": [
      "دائیں کندھے پر فرشتہ",
      "بائیں کندھے پر فرشتہ",
      "دونوں فرشتے",
      "جبریل (علیہ السلام)"
    ],
    "correctAnswer": "The angel on the right shoulder",
    "correctAnswerUrdu": "دائیں کندھے پر فرشتہ",
    "explanation":
        "The angel on the right shoulder (Raqib) records good deeds, while the one on the left (Atid) records bad deeds.",
    "explanationUrdu":
        "دائیں کندھے پر فرشتہ (رقیب) نیک اعمال لکھتا ہے، جبکہ بائیں طرف والا (عتید) برے اعمال لکھتا ہے۔"
  },
  {
    "question": "What is the name of Prophet Muhammad's (PBUH) camel?",
    "questionUrdu": "نبی محمد صلی اللہ علیہ وسلم کی اونٹنی کا نام کیا تھا؟",
    "options": ["Qaswa", "Adba", "Duldul", "Buraq"],
    "optionsUrdu": ["قصواء", "عضباء", "دلدل", "بروق"],
    "correctAnswer": "Qaswa",
    "correctAnswerUrdu": "قصواء",
    "explanation":
        "Al-Qaswa was the famous she-camel of Prophet Muhammad (PBUH) that he rode during the Hijra and other journeys.",
    "explanationUrdu":
        "القصواء نبی محمد صلی اللہ علیہ وسلم کی مشہور اونٹنی تھی جسے انہوں نے ہجرت اور دیگر سفر کے دوران سوار کیا۔"
  },
  {
    "question": "Which Surah is known as \"The Opening of the Quran\"?",
    "questionUrdu": "کون سی سورہ \"قرآن کا افتتاح\" کے نام سے مشہور ہے؟",
    "options": ["Al-Baqarah", "Al-Fatiha", "Al-Ikhlas", "An-Nas"],
    "optionsUrdu": ["البقرہ", "الفاتحہ", "الاخلاص", "الناس"],
    "correctAnswer": "Al-Fatiha",
    "correctAnswerUrdu": "الفاتحہ",
    "explanation":
        "Surah Al-Fatiha is called \"Fatihat al-Kitab\" (The Opening of the Book) as it opens the Quran.",
    "explanationUrdu":
        "سورہ الفاتحہ کو \"فاتحۃ الکتاب\" (کتاب کا افتتاح) کہا جاتا ہے کیونکہ یہ قرآن کا آغاز کرتی ہے۔"
  },
  {
    "question":
        "What is the Islamic term for the pre-Islamic period of ignorance?",
    "questionUrdu":
        "اسلام سے پہلے کے جاہلیت کے دور کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Jahiliyyah", "Shirk", "Kufr", "Dalal"],
    "optionsUrdu": ["جاہلیہ", "شرک", "کفر", "ضلالت"],
    "correctAnswer": "Jahiliyyah",
    "correctAnswerUrdu": "جاہلیہ",
    "explanation":
        "Jahiliyyah refers to the period of ignorance before Islam came, characterized by idol worship and social injustices.",
    "explanationUrdu":
        "جاہلیہ سے مراد اسلام سے پہلے کا دورِ جہالت ہے، جو بت پرستی اور سماجی ناانصافیوں سے منسوب ہے۔"
  },
  {
    "question": "Which prophet was saved from the belly of a big fish?",
    "questionUrdu": "کون سا نبی بڑی مچھلی کے پیٹ سے بچایا گیا؟",
    "options": ["Nuh (AS)", "Yunus (AS)", "Musa (AS)", "Lut (AS)"],
    "optionsUrdu": [
      "نوح (علیہ السلام)",
      "یونس (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "لوط (علیہ السلام)"
    ],
    "correctAnswer": "Yunus (AS)",
    "correctAnswerUrdu": "یونس (علیہ السلام)",
    "explanation":
        "Prophet Yunus (Jonah) was swallowed by a big fish but was saved when he repented and glorified Allah.",
    "explanationUrdu":
        "نبی یونس (علیہ السلام) کو ایک بڑی مچھلی نے نگل لیا تھا لیکن جب انہوں نے توبہ کی اور اللہ کی تسبیح کی تو وہ بچائے گئے۔"
  },
  {
    "question":
        "What is the name of the festival that celebrates the end of Ramadan?",
    "questionUrdu": "رمضان کے اختتام پر منایا جانے والا تہوار کا نام کیا ہے؟",
    "options": ["Eid al-Fitr", "Eid al-Adha", "Mawlid", "Ashura"],
    "optionsUrdu": ["عید الفطر", "عید الاضحی", "مولد", "عاشورہ"],
    "correctAnswer": "Eid al-Fitr",
    "correctAnswerUrdu": "عید الفطر",
    "explanation":
        "Eid al-Fitr is the festival of breaking the fast, celebrated at the end of the holy month of Ramadan.",
    "explanationUrdu":
        "عید الفطر روزہ توڑنے کا تہوار ہے، جو رمضان کے مقدس مہینے کے اختتام پر منایا جاتا ہے۔"
  },
  {
    "question": "Which companion was known for his vast wealth and generosity?",
    "questionUrdu": "کون سا صحابی اپنی وسیع دولت اور سخاوت کے لئے مشہور تھا؟",
    "options": [
      "Abu Bakr (RA)",
      "Abdur Rahman ibn Awf (RA)",
      "Uthman (RA)",
      "All of them"
    ],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "عبدالرحمن بن عوف (رضی اللہ عنہ)",
      "عثمان (رضی اللہ عنہ)",
      "ان سب"
    ],
    "correctAnswer": "All of them",
    "correctAnswerUrdu": "ان سب",
    "explanation":
        "Abu Bakr, Abdur Rahman ibn Awf, and Uthman (RA) were all known for their great wealth and exceptional generosity in Islam.",
    "explanationUrdu":
        "ابو بکر، عبدالرحمن بن عوف، اور عثمان (رضی اللہ عنہم) سب اپنی عظیم دولت اور اسلام میں غیر معمولی سخاوت کے لئے مشہور تھے۔"
  },
  {
    "question": "What is the Arabic word for paradise rivers?",
    "questionUrdu": "جنت کے نہروں کے لئے عربی لفظ کیا ہے؟",
    "options": ["Anhar", "Nahr", "Salsabil", "Kawthar"],
    "optionsUrdu": ["انہار", "نہر", "سلسبیل", "کوثر"],
    "correctAnswer": "Anhar",
    "correctAnswerUrdu": "انہار",
    "explanation":
        "Anhar (plural of Nahr) means rivers. Paradise has rivers of water, milk, honey, and wine that doesn't intoxicate.",
    "explanationUrdu":
        "انہار (نہر کا جمع) کا مطلب ہے نہریں۔ جنت میں پانی، دودھ، شہد، اور غیر نشہ آور شراب کی نہریں ہیں۔"
  },
  {
    "question": "Which prophet was given a ring with special powers?",
    "questionUrdu": "کون سے نبی کو خاص طاقتوں والی انگوٹھی دی گئی؟",
    "options": ["Sulaiman (AS)", "Dawud (AS)", "Ibrahim (AS)", "Yusuf (AS)"],
    "optionsUrdu": [
      "سلیمان (علیہ السلام)",
      "داوود (علیہ السلام)",
      "ابراہیم (علیہ السلام)",
      "یوسف (علیہ السلام)"
    ],
    "correctAnswer": "Sulaiman (AS)",
    "correctAnswerUrdu": "سلیمان (علیہ السلام)",
    "explanation":
        "Prophet Sulaiman (Solomon) was given a special ring that gave him power over jinn, animals, and the wind.",
    "explanationUrdu":
        "نبی سلیمان (علیہ السلام) کو ایک خاص انگوٹھی دی گئی جس سے انہیں جن، جانوروں اور ہوا پر قدرت حاصل تھی۔"
  },
  {
    "question":
        "What is the name of the special night in the last 10 nights of Ramadan?",
    "questionUrdu": "رمضان کی آخری 10 راتوں میں خصوصی رات کا نام کیا ہے؟",
    "options": [
      "Laylat al-Miraj",
      "Laylat al-Qadr",
      "Laylat al-Bara'ah",
      "Laylat al-Isra"
    ],
    "optionsUrdu": [
      "لیلۃ المعراج",
      "لیلۃ القدر",
      "لیلۃ البراءہ",
      "لیلۃ الاسراء"
    ],
    "correctAnswer": "Laylat al-Qadr",
    "correctAnswerUrdu": "لیلۃ القدر",
    "explanation":
        "Laylat al-Qadr (Night of Power/Decree) is the blessed night when the Quran was first revealed, better than 1000 months.",
    "explanationUrdu":
        "لیلۃ القدر (قدر کی رات) وہ مبارک رات ہے جب قرآن پہلی بار نازل ہوا، جو ایک ہزار مہینوں سے بہتر ہے۔"
  },
  {
    "question": "Which prophet was given the ability to raise the dead?",
    "questionUrdu": "کون سے نبی کو مردوں کو زندہ کرنے کی صلاحیت دی گئی؟",
    "options": ["Musa (AS)", "Isa (AS)", "Sulaiman (AS)", "Ibrahim (AS)"],
    "optionsUrdu": [
      "موسیٰ (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "سلیمان (علیہ السلام)",
      "ابراہیم (علیہ السلام)"
    ],
    "correctAnswer": "Isa (AS)",
    "correctAnswerUrdu": "عیسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Isa (Jesus) was given the miracle to bring the dead back to life with Allah's permission as a sign of his prophethood.",
    "explanationUrdu":
        "نبی عیسیٰ (علیہ السلام) کو اللہ کے اذن سے مردوں کو زندہ کرنے کا معجزہ دیا گیا جو ان کی نبوت کی نشانی تھی۔"
  },
  {
    "question":
        "What is the Islamic term for pilgrimage to places other than Mecca?",
    "questionUrdu":
        "مکہ کے علاوہ دیگر مقامات کی زیارت کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Hajj", "Umrah", "Ziyarah", "Safar"],
    "optionsUrdu": ["حج", "عمرہ", "زیارہ", "سفر"],
    "correctAnswer": "Ziyarah",
    "correctAnswerUrdu": "زیارہ",
    "explanation":
        "Ziyarah means visitation and refers to pilgrimage to holy places other than Mecca, like the Prophet's Mosque in Medina.",
    "explanationUrdu":
        "زیارہ کا مطلب زیارت ہے اور اس سے مراد مکہ کے علاوہ مقدس مقامات جیسے مدینہ میں نبی کی مسجد کی زیارت ہے۔"
  },
  {
    "question":
        "Which angel is responsible for the trumpet that will signal the Day of Judgment?",
    "questionUrdu": "کون سا فرشتہ قیامت کے دن کے اشارے کے لئے نرسنگا بجائے گا؟",
    "options": ["Jibreel (AS)", "Mikail (AS)", "Israfil (AS)", "Azrail (AS)"],
    "optionsUrdu": [
      "جبریل (علیہ السلام)",
      "میکائیل (علیہ السلام)",
      "اسرافیل (علیہ السلام)",
      "عزرائیل (علیہ السلام)"
    ],
    "correctAnswer": "Israfil (AS)",
    "correctAnswerUrdu": "اسرافیل (علیہ السلام)",
    "explanation":
        "Angel Israfil will blow the trumpet (Sur) twice: once to end all life, and once to resurrect everyone for Judgment.",
    "explanationUrdu":
        "فرشتہ اسرافیل نرسنگا (صور) دو بار بجائے گا: ایک بار تمام زندگی ختم کرنے کے لئے، اور ایک بار سب کو فیصلے کے لئے دوبارہ زندہ کرنے کے لئے۔"
  },
  {
    "question": "What is the name of the Prophet's (PBUH) sword?",
    "questionUrdu": "نبی صلی اللہ علیہ وسلم کی تلوار کا نام کیا تھا؟",
    "options": ["Dhul Fiqar", "Qadib", "Sayf", "Battar"],
    "optionsUrdu": ["ذوالفقار", "قضیب", "سیف", "بتر"],
    "correctAnswer": "Dhul Fiqar",
    "correctAnswerUrdu": "ذوالفقار",
    "explanation":
        "Dhul Fiqar was the famous sword of Prophet Muhammad (PBUH), later given to Ali (RA).",
    "explanationUrdu":
        "ذوالفقار نبی محمد صلی اللہ علیہ وسلم کی مشہور تلوار تھی، جو بعد میں علی (رضی اللہ عنہ) کو دی گئی۔"
  },
  {
    "question": "Which Surah mentions the story of the companions of the cave?",
    "questionUrdu": "کون سی سورہ غار کے اصحاب کی کہانی کا ذکر کرتی ہے؟",
    "options": ["Al-Kahf", "Al-Anfal", "At-Tawbah", "Maryam"],
    "optionsUrdu": ["الکہف", "الانفال", "التوبہ", "مریم"],
    "correctAnswer": "Al-Kahf",
    "correctAnswerUrdu": "الکہف",
    "explanation":
        "Surah Al-Kahf (The Cave) tells the story of young believers who slept in a cave for many years to escape persecution.",
    "explanationUrdu":
        "سورہ الکہف (غار) ان نوجوان مومنوں کی کہانی سناتی ہے جو ظلم سے بچنے کے لئے کئی سال تک غار میں سوئے رہے۔"
  },
  {
    "question": "What is the Arabic term for the inner self or ego?",
    "questionUrdu": "اندرونی نفس یا انا کے لئے عربی اصطلاح کیا ہے؟",
    "options": ["Ruh", "Nafs", "Qalb", "Aql"],
    "optionsUrdu": ["روح", "نفس", "قلب", "عقل"],
    "correctAnswer": "Nafs",
    "correctAnswerUrdu": "نفس",
    "explanation":
        "Nafs refers to the inner self or ego that can lead to either good or evil, depending on how it's trained and controlled.",
    "explanationUrdu":
        "نفس سے مراد اندرونی خود یا انا ہے جو اس کی تربیت اور کنٹرول کے مطابق اچھائی یا برائی کی طرف لے جا سکتا ہے۔"
  },
  {
    "question":
        "Which prophet was commanded to sacrifice his son but was given a ram instead?",
    "questionUrdu":
        "کون سے نبی کو اپنے بیٹے کی قربانی کا حکم دیا گیا لیکن اس کی جگہ مینڈھا دیا گیا؟",
    "options": ["Ibrahim (AS)", "Yaqub (AS)", "Ishaq (AS)", "Ismail (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "یعقوب (علیہ السلام)",
      "اسحاق (علیہ السلام)",
      "اسماعیل (علیہ السلام)"
    ],
    "correctAnswer": "Ibrahim (AS)",
    "correctAnswerUrdu": "ابراہیم (علیہ السلام)",
    "explanation":
        "Prophet Ibrahim (AS) was commanded to sacrifice his son Ismail (AS), but Allah provided a ram as a substitute.",
    "explanationUrdu":
        "نبی ابراہیم (علیہ السلام) کو اپنے بیٹے اسماعیل (علیہ السلام) کی قربانی کا حکم دیا گیا، لیکن اللہ نے اس کی جگہ ایک مینڈھا فراہم کیا۔"
  },
  {
    "question":
        "What is the name of the blessed tree under which the Prophet (PBUH) took allegiance?",
    "questionUrdu":
        "اس مبارک درخت کا نام کیا ہے جس کے نیچے نبی صلی اللہ علیہ وسلم نے بیعت لی؟",
    "options": ["Sidrat al-Muntaha", "Shajarat al-Ridwan", "Tuba", "Zaqqum"],
    "optionsUrdu": ["سدرۃ المنتہیٰ", "شجرۃ الرضوان", "طوبیٰ", "زقوم"],
    "correctAnswer": "Shajarat al-Ridwan",
    "correctAnswerUrdu": "شجرۃ الرضوان",
    "explanation":
        "Shajarat al-Ridwan (Tree of Allegiance) was where the Prophet (PBUH) took the pledge of Ridwan from his companions.",
    "explanationUrdu":
        "شجرۃ الرضوان (بیعت کا درخت) وہ جگہ تھی جہاں نبی صلی اللہ علیہ وسلم نے اپنے صحابہ سے رضوان کی بیعت لی۔"
  },
  {
    "question": "Which companion was known as \"The Collector of the Quran\"?",
    "questionUrdu":
        "کون سا صحابی \"قرآن کے جمع کرنے والا\" کے نام سے مشہور تھا؟",
    "options": [
      "Abu Bakr (RA)",
      "Umar (RA)",
      "Uthman (RA)",
      "Zaid ibn Thabit (RA)"
    ],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "عمر (رضی اللہ عنہ)",
      "عثمان (رضی اللہ عنہ)",
      "زید بن ثابت (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Zaid ibn Thabit (RA)",
    "correctAnswerUrdu": "زید بن ثابت (رضی اللہ عنہ)",
    "explanation":
        "Zaid ibn Thabit (RA) was the chief scribe who compiled the Quran into a single book under the first three Caliphs.",
    "explanationUrdu":
        "زید بن ثابت (رضی اللہ عنہ) وہ چیف کاتب تھے جنہوں نے پہلے تین خلفاء کے تحت قرآن کو ایک کتاب میں مرتب کیا۔"
  },
  {
    "question":
        "What is the Islamic term for the practice of Prophet Muhammad (PBUH)?",
    "questionUrdu":
        "نبی محمد صلی اللہ علیہ وسلم کی عمل کی اسلامی اصطلاح کیا ہے؟",
    "options": ["Hadith", "Sunnah", "Sirah", "Fiqh"],
    "optionsUrdu": ["حدیث", "سنت", "سیرت", "فقہ"],
    "correctAnswer": "Sunnah",
    "correctAnswerUrdu": "سنت",
    "explanation":
        "Sunnah refers to the practices, sayings, and approvals of Prophet Muhammad (PBUH) that Muslims follow as guidance.",
    "explanationUrdu":
        "سنت سے مراد نبی محمد صلی اللہ علیہ وسلم کے اعمال، اقوال اور منظوریاں ہیں جن کی مسلمان رہنمائی کے طور پر پیروی کرتے ہیں۔"
  },
  {
    "question": "Which prophet was given the Gospel (Injeel) as a holy book?",
    "questionUrdu": "کون سے نبی کو انجیل بطور مقدس کتاب دی گئی؟",
    "options": ["Musa (AS)", "Dawud (AS)", "Isa (AS)", "Muhammad (PBUH)"],
    "optionsUrdu": [
      "موسیٰ (علیہ السلام)",
      "داوود (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "محمد صلی اللہ علیہ وسلم"
    ],
    "correctAnswer": "Isa (AS)",
    "correctAnswerUrdu": "عیسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Isa (Jesus) was given the Injeel (Gospel) as divine guidance for his followers.",
    "explanationUrdu":
        "نبی عیسیٰ (علیہ السلام) کو ان کے پیروکاروں کے لئے الہی رہنمائی کے طور پر انجیل دی گئی۔"
  },
  {
    "question":
        "What is the name of the well that will provide water on the Day of Judgment?",
    "questionUrdu": "قیامت کے دن پانی فراہم کرنے والے کنویں کا نام کیا ہے؟",
    "options": ["Zamzam", "Hawd al-Kawthar", "Salsabil", "Tasnim"],
    "optionsUrdu": ["زمزم", "حوض کوثر", "سلسبیل", "تسنیم"],
    "correctAnswer": "Hawd al-Kawthar",
    "correctAnswerUrdu": "حوض کوثر",
    "explanation":
        "Hawd al-Kawthar is the blessed pool of Prophet Muhammad (PBUH) from which believers will drink on Judgment Day.",
    "explanationUrdu":
        "حوض کوثر نبی محمد صلی اللہ علیہ وسلم کا مبارک حوض ہے جس سے قیامت کے دن مومنین پانی پئیں گے۔"
  },
  {
    "question": "Which prophet was known for his skill in interpreting dreams?",
    "questionUrdu":
        "کون سا نبی خوابوں کی تعبیر میں اپنی مہارت کے لئے مشہور تھا؟",
    "options": ["Yusuf (AS)", "Daniel (AS)", "Muhammad (PBUH)", "All of them"],
    "optionsUrdu": [
      "یوسف (علیہ السلام)",
      "دانیال (علیہ السلام)",
      "محمد صلی اللہ علیہ وسلم",
      "ان سب"
    ],
    "correctAnswer": "All of them",
    "correctAnswerUrdu": "ان سب",
    "explanation":
        "Several prophets were known for dream interpretation: Yusuf (AS) especially, Daniel (AS), and Muhammad (PBUH) also interpreted dreams.",
    "explanationUrdu":
        "کئی انبیاء خوابوں کی تعبیر کے لئے مشہور تھے: خاص طور پر یوسف (علیہ السلام)، دانیال (علیہ السلام)، اور محمد صلی اللہ علیہ وسلم نے بھی خوابوں کی تعبیر کی۔"
  },
  {
    "question":
        "What is the Arabic word for the ritual purification with sand?",
    "questionUrdu": "ریت سے طہارت کے عمل کے لئے عربی لفظ کیا ہے؟",
    "options": ["Wudu", "Ghusl", "Tayammum", "Istinja"],
    "optionsUrdu": ["وضو", "غسل", "تیمم", "استنجاء"],
    "correctAnswer": "Tayammum",
    "correctAnswerUrdu": "تیمم",
    "explanation":
        "Tayammum is the dry ablution using clean sand or dust when water is not available for Wudu or Ghusl.",
    "explanationUrdu":
        "تیمم خشک طہارت ہے جو صاف ریت یا مٹی سے کی جاتی ہے جب وضو یا غسل کے لئے پانی میسر نہ ہو۔"
  },
  {
    "question": "Which battle is mentioned in Surah Al-Anfal?",
    "questionUrdu": "سورہ الانفال میں کون سی جنگ کا ذکر ہے؟",
    "options": [
      "Battle of Uhud",
      "Battle of Badr",
      "Battle of Khandaq",
      "Battle of Hunayn"
    ],
    "optionsUrdu": ["جنگ احد", "جنگ بدر", "جنگ خندق", "جنگ حنین"],
    "correctAnswer": "Battle of Badr",
    "correctAnswerUrdu": "جنگ بدر",
    "explanation":
        "Surah Al-Anfal primarily discusses the Battle of Badr and the rules regarding war spoils (Anfal).",
    "explanationUrdu":
        "سورہ الانفال بنیادی طور پر جنگ بدر اور جنگی غنائم (انفال) کے قواعد پر بحث کرتی ہے۔"
  },
  {
    "question": "What is the name of the special garment worn during Hajj?",
    "questionUrdu": "حج کے دوران پہنے جانے والے خصوصی لباس کا نام کیا ہے؟",
    "options": ["Thobe", "Ihram", "Qamis", "Jubba"],
    "optionsUrdu": ["تھوب", "احرام", "قمیص", "جبہ"],
    "correctAnswer": "Ihram",
    "correctAnswerUrdu": "احرام",
    "explanation":
        "Ihram consists of two white seamless cloths worn by male pilgrims during Hajj and Umrah, symbolizing equality and purity.",
    "explanationUrdu":
        "احرام دو سفید بغیر سلے کپڑوں پر مشتمل ہوتا ہے جو مرد حاجی حج اور عمرہ کے دوران پہنتے ہیں، جو مساوات اور پاکیزگی کی علامت ہے۔"
  },
  {
    "question": "Which prophet was given the Psalms (Zabur)?",
    "questionUrdu": "کون سے نبی کو زبور دیا گیا؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Dawud (AS)", "Sulaiman (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "داوود (علیہ السلام)",
      "سلیمان (علیہ السلام)"
    ],
    "correctAnswer": "Dawud (AS)",
    "correctAnswerUrdu": "داوود (علیہ السلام)",
    "explanation":
        "Prophet Dawud (David) was given the Zabur (Psalms) as a holy book containing hymns and praises to Allah.",
    "explanationUrdu":
        "نبی داوود (علیہ السلام) کو زبور (مزامیر) بطور مقدس کتاب دی گئی جس میں اللہ کی حمد و ثنا کے گیت شامل ہیں۔"
  },
  {
    "question": "What is the Islamic term for the community prayer?",
    "questionUrdu": "جماعتی نماز کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": [
      "Salat al-Jama'ah",
      "Salat al-Fard",
      "Salat al-Sunnah",
      "Salat al-Nafl"
    ],
    "optionsUrdu": ["صلاة الجماعہ", "صلاة الفرض", "صلاة السنہ", "صلاة النفل"],
    "correctAnswer": "Salat al-Jama'ah",
    "correctAnswerUrdu": "صلاة الجماعہ",
    "explanation":
        "Salat al-Jama'ah is the congregational prayer performed together in the mosque, which has greater reward than individual prayer.",
    "explanationUrdu":
        "صلاة الجماعہ وہ جماعتی نماز ہے جو مسجد میں ایک ساتھ ادا کی جاتی ہے، جس کا ثواب انفرادی نماز سے زیادہ ہے۔"
  },
  {
    "question":
        "Which companion was known as \"The Generous\" for buying a well for Muslims?",
    "questionUrdu":
        "کون سا صحابی مسلمانوں کے لئے کنواں خریدنے کی وجہ سے \"سخی\" کے نام سے مشہور تھا؟",
    "options": ["Abu Bakr (RA)", "Umar (RA)", "Uthman (RA)", "Ali (RA)"],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "عمر (رضی اللہ عنہ)",
      "عثمان (رضی اللہ عنہ)",
      "علی (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Uthman (RA)",
    "correctAnswerUrdu": "عثمان (رضی اللہ عنہ)",
    "explanation":
        "Uthman ibn Affan (RA) bought the well of Rumah and made it free for all Muslims to use, showing his great generosity.",
    "explanationUrdu":
        "عثمان بن عفان (رضی اللہ عنہ) نے رومہ کا کنواں خریدا اور اسے تمام مسلمانوں کے لئے مفت کردیا، جو ان کی عظیم سخاوت کو ظاہر کرتا ہے۔"
  },
  {
    "question":
        "What is the name of the bridge that connects this world to the next?",
    "questionUrdu": "اس دنیا کو اگلی دنیا سے ملانے والے پل کا نام کیا ہے؟",
    "options": ["Sirat", "Mizan", "Barzakh", "Hawd"],
    "optionsUrdu": ["صراط", "میزان", "برزخ", "حوض"],
    "correctAnswer": "Sirat",
    "correctAnswerUrdu": "صراط",
    "explanation":
        "As-Sirat is the bridge over hellfire that all souls must cross to reach Paradise on the Day of Judgment.",
    "explanationUrdu":
        "صراط وہ پل ہے جو جہنم کے اوپر سے جنت تک جاتا ہے اور قیامت کے دن تمام روحوں کو اسے عبور کرنا ہوگا۔"
  },
  {
    "question":
        "Which prophet was given control over the jinn and could understand animal speech?",
    "questionUrdu":
        "کون سے نبی کو جنوں پر کنٹرول اور جانوروں کی بات سمجھنے کی صلاحیت دی گئی؟",
    "options": ["Dawud (AS)", "Sulaiman (AS)", "Ibrahim (AS)", "Musa (AS)"],
    "optionsUrdu": [
      "داوود (علیہ السلام)",
      "سلیمان (علیہ السلام)",
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)"
    ],
    "correctAnswer": "Sulaiman (AS)",
    "correctAnswerUrdu": "سلیمان (علیہ السلام)",
    "explanation":
        "Prophet Sulaiman (Solomon) was uniquely given power over jinn and the ability to understand and communicate with animals.",
    "explanationUrdu":
        "نبی سلیمان (علیہ السلام) کو منفرد طور پر جنوں پر قدرت اور جانوروں کے ساتھ سمجھنے اور بات چیت کرنے کی صلاحیت دی گئی۔"
  },
  {
    "question":
        "What is the Arabic term for the migration from Mecca to Medina?",
    "questionUrdu": "مکہ سے مدینہ کی ہجرت کے لئے عربی اصطلاح کیا ہے؟",
    "options": ["Isra", "Miraj", "Hijra", "Safar"],
    "optionsUrdu": ["اسراء", "معراج", "ہجرت", "سفر"],
    "correctAnswer": "Hijra",
    "correctAnswerUrdu": "ہجرت",
    "explanation":
        "Hijra is the historic migration of Prophet Muhammad (PBUH) and his companions from Mecca to Medina in 622 CE.",
    "explanationUrdu":
        "ہجرت نبی محمد صلی اللہ علیہ وسلم اور ان کے صحابہ کی 622 عیسوی میں مکہ سے مدینہ کی تاریخی ہجرت ہے۔"
  },
  {
    "question": "Which angel brings sustenance and controls natural phenomena?",
    "questionUrdu":
        "کون سا فرشتہ رزق لاتا ہے اور فطری مظاہر کو کنٹرول کرتا ہے؟",
    "options": ["Jibreel (AS)", "Mikail (AS)", "Israfil (AS)", "Azrail (AS)"],
    "optionsUrdu": [
      "جبریل (علیہ السلام)",
      "میکائیل (علیہ السلام)",
      "اسرافیل (علیہ السلام)",
      "عزرائیل (علیہ السلام)"
    ],
    "correctAnswer": "Mikail (AS)",
    "correctAnswerUrdu": "میکائیل (علیہ السلام)",
    "explanation":
        "Angel Mikail (Michael) is responsible for distributing sustenance and controlling natural phenomena like rain, wind, and weather.",
    "explanationUrdu":
        "فرشتہ میکائیل (مایکل) رزق کی تقسیم اور بارش، ہوا اور موسم جیسے فطری مظاہر کو کنٹرول کرنے کے ذمہ دار ہیں۔"
  },
  {
    "question": "What is the name of the special prayer performed during Eid?",
    "questionUrdu": "عید کے دوران ادا کی جانے والی خصوصی نماز کا نام کیا ہے؟",
    "options": [
      "Salat al-Eid",
      "Salat al-Jumu'ah",
      "Salat al-Janazah",
      "Salat al-Kusuf"
    ],
    "optionsUrdu": ["صلاة العید", "صلاة الجمعہ", "صلاة الجنازہ", "صلاة الکسوف"],
    "correctAnswer": "Salat al-Eid",
    "correctAnswerUrdu": "صلاة العید",
    "explanation":
        "Salat al-Eid is the special prayer performed on both Eid al-Fitr and Eid al-Adha, consisting of 2 Rakats with extra Takbirs.",
    "explanationUrdu":
        "صلاة العید وہ خصوصی نماز ہے جو عید الفطر اور عید الاضحی دونوں پر ادا کی جاتی ہے، جس میں 2 رکعت اضافی تکبیروں کے ساتھ ہوتی ہیں۔"
  },
  {
    "question": "Which prophet was saved from Pharaoh as a baby?",
    "questionUrdu": "کون سا نبی بچپن میں فرعون سے بچایا گیا؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Harun (AS)", "Yusuf (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "ہارون (علیہ السلام)",
      "یوسف (علیہ السلام)"
    ],
    "correctAnswer": "Musa (AS)",
    "correctAnswerUrdu": "موسیٰ (علیہ السلام)",
    "explanation":
        "Baby Musa (Moses) was saved from Pharaoh's decree to kill all Hebrew male babies when his mother put him in a basket on the river.",
    "explanationUrdu":
        "نبی موسیٰ (علیہ السلام) کو فرعون کے اس حکم سے بچایا گیا کہ تمام عبرانی مرد بچوں کو قتل کیا جائے جب ان کی والدہ نے انہیں دریا پر ایک ٹوکری میں رکھا۔"
  },
  {
    "question": "What is the Islamic term for the love and fear of Allah?",
    "questionUrdu": "اللہ سے محبت اور خوف کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Iman", "Islam", "Ihsan", "Taqwa"],
    "optionsUrdu": ["ایمان", "اسلام", "احسان", "تقویٰ"],
    "correctAnswer": "Taqwa",
    "correctAnswerUrdu": "تقویٰ",
    "explanation":
        "Taqwa is God-consciousness - the love, fear, and awareness of Allah that guides a Muslim's actions and decisions.",
    "explanationUrdu":
        "تقویٰ خدا شعوری ہے - اللہ سے محبت، خوف اور آگاہی جو ایک مسلمان کے اعمال اور فیصلوں کی رہنمائی کرتی ہے۔"
  },
  {
    "question": "Which Surah is recited in every Rakat of prayer?",
    "questionUrdu": "ہر رکعت کی نماز میں کون سی سورہ پڑھی جاتی ہے؟",
    "options": ["Al-Baqarah", "Al-Fatiha", "Al-Ikhlas", "An-Nas"],
    "optionsUrdu": ["البقرہ", "الفاتحہ", "الاخلاص", "الناس"],
    "correctAnswer": "Al-Fatiha",
    "correctAnswerUrdu": "الفاتحہ",
    "explanation":
        "Surah Al-Fatiha must be recited in every Rakat of every prayer, making it the most frequently recited chapter of the Quran.",
    "explanationUrdu":
        "سورہ الفاتحہ ہر نماز کی ہر رکعت میں پڑھنا ضروری ہے، جو اسے قرآن کا سب سے زیادہ پڑھا جانے والا باب بناتی ہے۔"
  },
  {
    "question":
        "What is the name of the fast observed on the 10th of Muharram?",
    "questionUrdu": "محرم کی 10 تاریخ کو رکھے جانے والے روزے کا نام کیا ہے؟",
    "options": [
      "Fast of Ramadan",
      "Fast of Ashura",
      "Fast of Arafah",
      "Fast of Shawwal"
    ],
    "optionsUrdu": [
      "رمضان کا روزہ",
      "عاشورہ کا روزہ",
      "عرفہ کا روزہ",
      "شوال کا روزہ"
    ],
    "correctAnswer": "Fast of Ashura",
    "correctAnswerUrdu": "عاشورہ کا روزہ",
    "explanation":
        "The fast of Ashura is observed on the 10th day of Muharram, commemorating various historical events including Musa's (AS) escape from Pharaoh.",
    "explanationUrdu":
        "عاشورہ کا روزہ محرم کی 10 تاریخ کو رکھا جاتا ہے، جو مختلف تاریخی واقعات کی یاد میں ہوتا ہے بشمول موسیٰ (علیہ السلام) کے فرعون سے فرار۔"
  },
  {
    "question":
        "Which companion was known for his beautiful voice in recitation?",
    "questionUrdu":
        "کون سا صحابی تلاوت میں اپنی خوبصورت آواز کے لئے مشہور تھا؟",
    "options": [
      "Abu Bakr (RA)",
      "Abu Musa al-Ash'ari (RA)",
      "Bilal (RA)",
      "Salim (RA)"
    ],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "ابو موسیٰ الاشعری (رضی اللہ عنہ)",
      "بلال (رضی اللہ عنہ)",
      "سالم (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Abu Musa al-Ash'ari (RA)",
    "correctAnswerUrdu": "ابو موسیٰ الاشعری (رضی اللہ عنہ)",
    "explanation":
        "Abu Musa al-Ash'ari (RA) was praised by the Prophet (PBUH) for having been given a beautiful voice like the flutes of the family of Dawud.",
    "explanationUrdu":
        "ابو موسیٰ الاشعری (رضی اللہ عنہ) کی نبی صلی اللہ علیہ وسلم نے تعریف کی کہ انہیں داوود کے خاندان کی بانسریوں جیسی خوبصورت آواز دی گئی۔"
  },
  {
    "question": "What is the Arabic word for the soul's journey after death?",
    "questionUrdu": "موت کے بعد روح کے سفر کے لئے عربی لفظ کیا ہے؟",
    "options": ["Barzakh", "Ruh", "Nafs", "Qiyamah"],
    "optionsUrdu": ["برزخ", "روح", "نفس", "قیامہ"],
    "correctAnswer": "Barzakh",
    "correctAnswerUrdu": "برزخ",
    "explanation":
        "Barzakh is the intermediate state between death and the Day of Judgment where souls await resurrection.",
    "explanationUrdu":
        "برزخ موت اور قیامت کے دن کے درمیان کا درمیانی عالم ہے جہاں روحیں دوبارہ زندہ ہونے کا انتظار کرتی ہیں۔"
  },
  {
    "question": "Which prophet was given the miracle of splitting the sea?",
    "questionUrdu": "کون سے نبی کو سمندر پھاڑنے کا معجزہ دیا گیا؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Nuh (AS)", "Sulaiman (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "نوح (علیہ السلام)",
      "سلیمان (علیہ السلام)"
    ],
    "correctAnswer": "Musa (AS)",
    "correctAnswerUrdu": "موسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Musa (Moses) was given the miracle of splitting the Red Sea to save the Israelites from Pharaoh's army.",
    "explanationUrdu":
        "نبی موسیٰ (علیہ السلام) کو بحر احمر پھاڑنے کا معجزہ دیا گیا تاکہ بنی اسرائیل کو فرعون کی فوج سے بچایا جا سکے۔"
  },
  {
    "question":
        "What is the name of the special prayer for seeking Allah's guidance?",
    "questionUrdu": "اللہ کی رہنمائی مانگنے کے لئے خصوصی نماز کا نام کیا ہے؟",
    "options": [
      "Salat al-Istikharah",
      "Salat al-Hajah",
      "Salat al-Tawbah",
      "Salat al-Shukr"
    ],
    "optionsUrdu": [
      "صلاة الاستخارہ",
      "صلاة الحاجہ",
      "صلاة التوبہ",
      "صلاة الشکر"
    ],
    "correctAnswer": "Salat al-Istikharah",
    "correctAnswerUrdu": "صلاة الاستخارہ",
    "explanation":
        "Salat al-Istikharah is the prayer of seeking guidance from Allah when making important decisions in life.",
    "explanationUrdu":
        "صلاة الاستخارہ وہ نماز ہے جو زندگی میں اہم فیصلے کرنے کے وقت اللہ سے رہنمائی مانگنے کے لئے ادا کی جاتی ہے۔"
  },
  {
    "question": "Which angel is known as the \"Spirit of Holiness\"?",
    "questionUrdu": "کون سا فرشتہ \"روح القدس\" کے نام سے جانا جاتا ہے؟",
    "options": ["Jibreel (AS)", "Mikail (AS)", "Israfil (AS)", "Azrail (AS)"],
    "optionsUrdu": [
      "جبریل (علیہ السلام)",
      "میکائیل (علیہ السلام)",
      "اسرافیل (علیہ السلام)",
      "عزرائیل (علیہ السلام)"
    ],
    "correctAnswer": "Jibreel (AS)",
    "correctAnswerUrdu": "جبریل (علیہ السلام)",
    "explanation":
        "Angel Jibreel (Gabriel) is referred to as \"Ruh al-Qudus\" (Spirit of Holiness) in the Quran for bringing divine revelations.",
    "explanationUrdu":
        "فرشتہ جبریل (جبرائیل) کو قرآن میں \"روح القدس\" کہا جاتا ہے کیونکہ وہ الہی وحی لاتے ہیں۔"
  },
  {
    "question":
        "What is the Islamic term for the scales that will weigh deeds?",
    "questionUrdu": "اعمال تولنے والی ترازو کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Sirat", "Mizan", "Hawd", "Lawh"],
    "optionsUrdu": ["صراط", "میزان", "حوض", "لوح"],
    "correctAnswer": "Mizan",
    "correctAnswerUrdu": "میزان",
    "explanation":
        "Al-Mizan is the divine scale that will weigh people's good and bad deeds on the Day of Judgment.",
    "explanationUrdu":
        "المیزان وہ الہی ترازو ہے جو قیامت کے دن لوگوں کے اچھے اور برے اعمال کو تولے گی۔"
  },
  {
    "question": "Which prophet was given a book written on stone tablets?",
    "questionUrdu": "کون سے نبی کو پتھر کی تختیوں پر لکھی گئی کتاب دی گئی؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Dawud (AS)", "Isa (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "داوود (علیہ السلام)",
      "عیسیٰ (علیہ السلام)"
    ],
    "correctAnswer": "Musa (AS)",
    "correctAnswerUrdu": "موسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Musa (Moses) received the Torah written on stone tablets from Allah on Mount Sinai.",
    "explanationUrdu":
        "نبی موسیٰ (علیہ السلام) کو اللہ سے جبل سینا پر پتھر کی تختیوں پر لکھی گئی تورات دی گئی۔"
  },
  {
    "question":
        "What is the name of the special night prayer during the last 10 nights of Ramadan?",
    "questionUrdu":
        "رمضان کی آخری 10 راتوں میں خصوصی رات کی نماز کا نام کیا ہے؟",
    "options": ["Tahajjud", "Tarawih", "Qiyam", "I'tikaf prayer"],
    "optionsUrdu": ["تہجد", "تراویح", "قیام", "اعتکاف کی نماز"],
    "correctAnswer": "Qiyam",
    "correctAnswerUrdu": "قیام",
    "explanation":
        "Qiyam al-Layl (standing in prayer at night) is especially emphasized during the last 10 nights of Ramadan to catch Laylat al-Qadr.",
    "explanationUrdu":
        "قیام اللیل (رات کو نماز میں کھڑے ہونا) رمضان کی آخری 10 راتوں میں خاص طور پر زور دیا جاتا ہے تاکہ لیلۃ القدر حاصل کی جا سکے۔"
  },
  {
    "question":
        "Which companion was the first to compile the Quran in book form?",
    "questionUrdu":
        "کون سا صحابی سب سے پہلے قرآن کو کتابی شکل میں مرتب کرنے والا تھا؟",
    "options": ["Abu Bakr (RA)", "Umar (RA)", "Uthman (RA)", "Ali (RA)"],
    "optionsUrdu": [
      "ابو بکر (رضی اللہ عنہ)",
      "عمر (رضی اللہ عنہ)",
      "عثمان (رضی اللہ عنہ)",
      "علی (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Abu Bakr (RA)",
    "correctAnswerUrdu": "ابو بکر (رضی اللہ عنہ)",
    "explanation":
        "The Quran was first compiled into a single book during the Caliphate of Abu Bakr (RA) after many memorizers died in battle.",
    "explanationUrdu":
        "قرآن سب سے پہلے ابو بکر (رضی اللہ عنہ) کی خلافت کے دوران ایک کتاب میں مرتب کیا گیا جب بہت سے حفاظ جنگ میں شہید ہوئے۔"
  },
  {
    "question": "What is the Islamic term for the eternal punishment in hell?",
    "questionUrdu": "جہنم میں ابدی سزا کے لئے اسلامی اصطلاح کیا ہے؟",
    "options": ["Akhirah", "Jahannam", "Khalid", "Sa'ir"],
    "optionsUrdu": ["آخرت", "جہنم", "خالد", "سعیر"],
    "correctAnswer": "Khalid",
    "correctAnswerUrdu": "خالد",
    "explanation":
        "Khalid means \"eternal\" or \"forever,\" used to describe the permanent nature of punishment in hell for disbelievers.",
    "explanationUrdu":
        "خالد کا مطلب ہے \"ابدی\" یا \"ہمیشہ کے لئے،\" جو کافروں کے لئے جہنم میں سزا کی مستقل نوعیت کو بیان کرنے کے لئے استعمال ہوتا ہے۔"
  },
  {
    "question":
        "Which prophet was known for his patience during severe illness?",
    "questionUrdu":
        "کون سا نبی شدید بیماری کے دوران اپنے صبر کے لئے مشہور تھا؟",
    "options": ["Ayyub (AS)", "Yaqub (AS)", "Zakariya (AS)", "Ibrahim (AS)"],
    "optionsUrdu": [
      "ایوب (علیہ السلام)",
      "یعقوب (علیہ السلام)",
      "زکریا (علیہ السلام)",
      "ابراہیم (علیہ السلام)"
    ],
    "correctAnswer": "Ayyub (AS)",
    "correctAnswerUrdu": "ایوب (علیہ السلام)",
    "explanation":
        "Prophet Ayyub (Job) is most famous for his extraordinary patience (sabr) during years of severe illness and hardship.",
    "explanationUrdu":
        "نبی ایوب (علیہ السلام) اپنے غیر معمولی صبر (صبر) کے لئے سب سے زیادہ مشہور ہیں جو شدید بیماری اور مشکلات کے سالوں کے دوران دکھایا۔"
  },
  {
    "question": "What is the name of the special charity box in mosques?",
    "questionUrdu": "مساجد میں خصوصی خیرات کے ڈبے کا نام کیا ہے؟",
    "options": ["Zakat box", "Sadaqah box", "Both are correct", "Khairat box"],
    "optionsUrdu": [
      "زکوٰۃ کا ڈبہ",
      "صدقہ کا ڈبہ",
      "دونوں درست ہیں",
      "خیرات کا ڈبہ"
    ],
    "correctAnswer": "Both are correct",
    "correctAnswerUrdu": "دونوں درست ہیں",
    "explanation":
        "Charity boxes in mosques are called both Zakat boxes and Sadaqah boxes, as they collect both obligatory and voluntary charity.",
    "explanationUrdu":
        "مساجد میں خیرات کے ڈبوں کو زکوٰۃ کے ڈبے اور صدقہ کے ڈبے دونوں کہا جاتا ہے، کیونکہ وہ واجب اور رضا کارانہ خیرات دونوں جمع کرتے ہیں۔"
  },
  {
    "question":
        "Which prophet was given the miracle of making birds from clay?",
    "questionUrdu": "کون سے نبی کو مٹی سے پرندے بنانے کا معجزہ دیا گیا؟",
    "options": ["Ibrahim (AS)", "Musa (AS)", "Isa (AS)", "Sulaiman (AS)"],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "عیسیٰ (علیہ السلام)",
      "سلیمان (علیہ السلام)"
    ],
    "correctAnswer": "Isa (AS)",
    "correctAnswerUrdu": "عیسیٰ (علیہ السلام)",
    "explanation":
        "Prophet Isa (Jesus) was given the miracle to breathe life into clay birds, making them fly as a sign of his prophethood.",
    "explanationUrdu":
        "نبی عیسیٰ (علیہ السلام) کو مٹی کے پرندوں میں جان ڈالنے کا معجزہ دیا گیا، جو ان کی نبوت کی نشانی کے طور پر اڑتے تھے۔"
  },
  {
    "question": "What is the Arabic term for the first Muslim community?",
    "questionUrdu": "پہلی مسلم کمیونٹی کے لئے عربی اصطلاح کیا ہے؟",
    "options": [
      "Ummah Muslimah",
      "Ummah Wahidah",
      "Ummah Ula",
      "As-Sabiqun al-Awwalun"
    ],
    "optionsUrdu": ["امہ مسلمہ", "امہ واحدہ", "امہ اولیٰ", "السابقون الاولون"],
    "correctAnswer": "As-Sabiqun al-Awwalun",
    "correctAnswerUrdu": "السابقون الاولون",
    "explanation":
        "As-Sabiqun al-Awwalun refers to the first and foremost Muslims who accepted Islam early and made great sacrifices.",
    "explanationUrdu":
        "السابقون الاولون سے مراد وہ اولین اور سب سے آگے والے مسلمان ہیں جنہوں نے ابتدائی طور پر اسلام قبول کیا اور بڑی قربانیاں دیں۔"
  },
  {
    "question": "Which companion was known as the \"Treasure of Knowledge\"?",
    "questionUrdu": "کون سا صحابی \"علم کا خزانہ\" کے نام سے مشہور تھا؟",
    "options": [
      "Ibn Abbas (RA)",
      "Ibn Mas'ud (RA)",
      "Abu Hurairah (RA)",
      "Mu'adh ibn Jabal (RA)"
    ],
    "optionsUrdu": [
      "ابن عباس (رضی اللہ عنہ)",
      "ابن مسعود (رضی اللہ عنہ)",
      "ابو ہریرہ (رضی اللہ عنہ)",
      "معاذ بن جبل (رضی اللہ عنہ)"
    ],
    "correctAnswer": "Ibn Abbas (RA)",
    "correctAnswerUrdu": "ابن عباس (رضی اللہ عنہ)",
    "explanation":
        "Abdullah ibn Abbas (RA) was called \"Hibr al-Ummah\" (Scholar of the Nation) and \"Treasure of Knowledge\" for his vast Islamic knowledge.",
    "explanationUrdu":
        "عبداللہ بن عباس (رضی اللہ عنہ) کو \"حبر الامہ\" (امہ کا عالم) اور \"علم کا خزانہ\" کہا جاتا تھا کیونکہ ان کے پاس اسلامی علم کا وسیع ذخیرہ تھا۔"
  },
  {
    "question": "What is the reward mentioned for reciting Surah Al-Ikhlas?",
    "questionUrdu": "سورہ الاخلاص پڑھنے کا ذکر کردہ اجر کیا ہے؟",
    "options": [
      "Equal to 1/10 of Quran",
      "Equal to 1/3 of Quran",
      "Equal to 1/2 of Quran",
      "Equal to full Quran"
    ],
    "optionsUrdu": [
      "قرآن کے 1/10 کے برابر",
      "قرآن کے 1/3 کے برابر",
      "قرآن کے 1/2 کے برابر",
      "پورے قرآن کے برابر"
    ],
    "correctAnswer": "Equal to 1/3 of Quran",
    "correctAnswerUrdu": "قرآن کے 1/3 کے برابر",
    "explanation":
        "Prophet Muhammad (PBUH) said that reciting Surah Al-Ikhlas is equal to reciting one-third of the Quran in reward.",
    "explanationUrdu":
        "نبی محمد صلی اللہ علیہ وسلم نے فرمایا کہ سورہ الاخلاص پڑھنا ثواب میں قرآن کے ایک تہائی کے برابر ہے۔"
  },
  {
    "question": "Which prophet was saved from a burning furnace?",
    "questionUrdu": "کون سا نبی جلتی ہوئی بھٹی سے بچایا گیا؟",
    "options": [
      "Ibrahim (AS)",
      "Musa (AS)",
      "Daniel (AS)",
      "The story refers to other righteous people"
    ],
    "optionsUrdu": [
      "ابراہیم (علیہ السلام)",
      "موسیٰ (علیہ السلام)",
      "دانیال (علیہ السلام)",
      "یہ کہانی دیگر نیک لوگوں سے متعلق ہے"
    ],
    "correctAnswer": "Ibrahim (AS)",
    "correctAnswerUrdu": "ابراہیم (علیہ السلام)",
    "explanation":
        "Prophet Ibrahim (AS) was thrown into a fire by Nimrod but was saved when Allah made the fire cool and peaceful for him.",
    "explanationUrdu":
        "نبی ابراہیم (علیہ السلام) کو نمرود نے آگ میں پھینکا لیکن اللہ نے آگ کو ان کے لئے ٹھنڈی اور پرامن بنا کر بچایا۔"
  }
];
