class AiRepository {
  const AiRepository();

  Future<String> ask(String prompt) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return 'Dựa trên mục tiêu của bạn, Sisu gợi ý tập Push/Pull/Legs 4 buổi/tuần. Hôm nay nên tập Push nhẹ: Bench Press 4x5, Shoulder Press 3x8, Triceps Pushdown 3x12. Nếu reps cuối bị chậm, giữ mức tạ tuần này thay vì tăng.';
  }
}
