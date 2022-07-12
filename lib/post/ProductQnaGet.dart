class ProductQnaGet {
  final int productNumber;
  final int userNumber;
  final String qnaContents;
  final String qnaDate;
  final String qnaAnswer;
  final String userId;

  ProductQnaGet(
      {required this.productNumber,
      required this.userNumber,
      required this.qnaContents,
      required this.qnaDate,
      required this.qnaAnswer,
      required this.userId});
  factory ProductQnaGet.fromJson(Map<String, dynamic> json) {
    return ProductQnaGet(
        productNumber: json['q_product_number'],
        userNumber: json['q_user_number'],
        qnaContents: json['q_qna_contents'],
        qnaDate: json['q_qna_date'],
        qnaAnswer: json['q_qna_answer'],
        userId: json['u_user_id']);
  }
}
