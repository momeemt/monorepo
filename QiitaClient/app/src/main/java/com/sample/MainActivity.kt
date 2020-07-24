package com.sample

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.sample.model.Article
import com.sample.model.User
import com.sample.view.ArticleView

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val articleView = ArticleView(applicationContext)

        articleView.setArticle(Article(
            id = "123",
            title = "Kotlin入門",
            url = "http://www.example.com/articles/123",
            user = User(id = "456", name = "momeemt", profileImageUrl = "")
        ))

        // setContentView(R.layout.activity_main)

        setContentView(articleView)
    }
}
