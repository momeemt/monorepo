package sample

fun main(args:Array<String>){
  val result = succ(31) //resultは型推論によって値を受け取る
  println(result)
}

fun succ(i:Int): Int = i + 1 
