package work.momee.calcalator

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val displayNumberTextView = findViewById<TextView>(R.id.display_number)

        val oneButton = findViewById<Button>(R.id.one_button)
        val twoButton = findViewById<Button>(R.id.two_button)
        val threeButton = findViewById<Button>(R.id.three_button)
        val fourButton = findViewById<Button>(R.id.four_button)
        val fiveButton = findViewById<Button>(R.id.five_button)
        val sixButton = findViewById<Button>(R.id.six_button)
        val sevenButton = findViewById<Button>(R.id.seven_button)
        val eightButton = findViewById<Button>(R.id.eight_button)
        val nineButton = findViewById<Button>(R.id.nine_button)
        val zeroButton = findViewById<Button>(R.id.zero_button)
        val zero2Button = findViewById<Button>(R.id.zero2_button)

        val dotButton = findViewById<Button>(R.id.dot_button)

        val allClearButton = findViewById<Button>(R.id.all_clear_button)
        val clearButton = findViewById<Button>(R.id.clear_button)

        val plusButton = findViewById<Button>(R.id.plus_button)
        val minusButton = findViewById<Button>(R.id.minus_button)
        val productButton = findViewById<Button>(R.id.product_button)
        val divideButton = findViewById<Button>(R.id.divide_button)
        val equalButton = findViewById<Button>(R.id.equal_button)

        var res = 0.0
        var temporaryNumber = 0.0
        var operationCode = ""

        fun changeText() {
            if (Math.ceil(res) == res) {
                displayNumberTextView.text = res.toInt().toString()
            } else {
                displayNumberTextView.text = res.toString()
            }
        }

        oneButton.setOnClickListener {
            res = res * 10 + 1
            changeText()
        }

        twoButton.setOnClickListener {
            res = res * 10 + 2
            changeText()
        }

        threeButton.setOnClickListener {
            res = res * 10 + 3
            changeText()
        }

        fourButton.setOnClickListener {
            res = res * 10 + 4
            changeText()
        }

        fiveButton.setOnClickListener {
            res = res * 10 + 5
            changeText()
        }

        sixButton.setOnClickListener {
            res = res * 10 + 6
            changeText()
        }

        sevenButton.setOnClickListener {
            res = res * 10 + 7
            changeText()
        }

        eightButton.setOnClickListener {
            res = res * 10 + 8
            changeText()
        }

        nineButton.setOnClickListener {
            res = res * 10 + 9
            changeText()
        }

        zeroButton.setOnClickListener {
            res *= 10
            changeText()
        }

        zero2Button.setOnClickListener {
            res *= 100
            changeText()
        }
        
        allClearButton.setOnClickListener {
            res = 0.0
            temporaryNumber = 0.0
            changeText()
        }

        clearButton.setOnClickListener {
            res = 0.0
            changeText()
        }

        plusButton.setOnClickListener {
            temporaryNumber = res
            res = 0.0
            operationCode = "plus"
        }

        minusButton.setOnClickListener {
            temporaryNumber = res
            res = 0.0
            operationCode = "minus"
        }

        productButton.setOnClickListener {
            temporaryNumber = res
            res = 0.0
            operationCode = "product"
        }

        divideButton.setOnClickListener {
            temporaryNumber = res
            res = 0.0
            operationCode = "divide"
        }

        equalButton.setOnClickListener {
            when (operationCode) {
                "plus" -> {
                    res += temporaryNumber
                }

                "minus" -> {
                    res = temporaryNumber - res
                }

                "product" -> {
                    res *= temporaryNumber
                }

                "divide" -> {
                    res = temporaryNumber / res
                }
            }
            temporaryNumber = 0.0
            operationCode = ""
            changeText()
        }
    }
}
