class DataProvider {
  static const String baseUrl = "http://critssl.com/tutionLms";
  static String subjectUrl() {
    return "$baseUrl/subject.php";
  }

  static String moduleUrl({required String subjectId}) {
    return "$baseUrl/module.php?subject=$subjectId";
  }

  static String contentUrl({required String moduleId}) {
    return "$baseUrl/content.php?module=$moduleId";
  }

  static String questionUrl({required moduleId}) {
    return "$baseUrl/question.php?module=$moduleId";
  }

  static String contentCountBySubUrl({required subjectId}) {
    return "$baseUrl/content.php?subject=$subjectId";
  }

  static String questionCountBySubUrl({required subjectId}) {
    return "$baseUrl/question.php?subject=$subjectId";
  }

  static String pdfDownloadLink({required String path}) {
    return "$baseUrl/$path";
  }
}
