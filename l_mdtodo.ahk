


test="(a) 강남대로 +AB프로젝트 @08월"




;--------스트링을 읽으면 거기서 관련된 데이터 뽑아주기
parseTodoTxt(todotxt){
todoArray = []

context := RegExMatch(todotxt,"(@\w+")






return todoArray
}