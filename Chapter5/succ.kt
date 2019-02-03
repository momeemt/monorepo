package sample

fun main(args:Array<String>){
  val result = succ(31) //resultは型推論によって値を受け取る
  println(result)
  println(square(7))
  println(hello("Momiyama"))
  println(max(12,13))
}

fun succ(i:Int): Int = i + 1

fun square(i:Int): Int = i * i

fun hello(name:String): String = "Hello, $name!"

fun max(a:Int,b:Int): Int = if(b <= a) a else b
