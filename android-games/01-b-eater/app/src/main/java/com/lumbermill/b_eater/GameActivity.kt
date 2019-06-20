package com.lumbermill.b_eater

import android.graphics.drawable.AnimationDrawable
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.ImageView
import kotlinx.android.synthetic.main.activity_home.*

class GameActivity : AppCompatActivity() {
    private lateinit var rocketAnimation: AnimationDrawable

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_game)

        val image = findViewById<ImageView>(R.id.sonid).apply {
            setBackgroundResource(R.drawable.son)
            rocketAnimation = background as AnimationDrawable
        }

        rocketAnimation.start()

    }
}
