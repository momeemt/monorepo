package sample

fun main(args:Array<String>){
  println(sub(minuend = 6,subtrahend = 2))
  println(hello())
  println(hello("Momiyama"))
}

fun sub(minuend:Int,subtrahend:Int):Int = minuend - subtrahend

fun hello(name:String = "World"):String = "Hello,$name!"
