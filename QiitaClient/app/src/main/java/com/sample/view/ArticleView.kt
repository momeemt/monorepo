package com.sample.view

import android.content.Context
import android.graphics.Color
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.TextView
import com.sample.R
import com.sample.model.Article
import org.w3c.dom.Text

class ArticleView : FrameLayout {
    constructor(context: Context?) : super(context!!)

    constructor(context: Context?,
                attrs: AttributeSet?) : super(context!!, attrs)

    constructor(context: Context?,
                attrs: AttributeSet?,
                defStyleAttr: Int) : super(context!!, attrs, defStyleAttr)

    constructor(context: Context?,
                attrs: AttributeSet?,
                defStyleAttr: Int,
                defStyleRes: Int) : super(context!!, attrs, defStyleAttr, defStyleRes)

    val profileImageView: ImageView by lazy {
        findViewById(R.id.profile_image_view) as ImageView
    }

    val titleTextView: TextView by lazy {
        findViewById(R.id.title_text_view) as TextView
    }

    val userNameTextView: TextView by lazy {
        findViewById(R.id.user_name_text_view) as TextView
    }

    init {
        LayoutInflater.from(context).inflate(R.layout.view_article, this)
    }

    fun setArticle(article: Article) {
        titleTextView.text = article.title
        userNameTextView.text = article.user.name

        // プロフィール画面をセットする
        profileImageView.setBackgroundColor(Color.RED)
    }
}