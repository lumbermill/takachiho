package com.lumbermill.b_eater

import android.graphics.drawable.AnimationDrawable
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.widget.ImageView
import android.widget.Toast
import androidx.core.os.postDelayed
import kotlinx.android.synthetic.main.activity_home.*
import java.util.*
import kotlin.random.Random
import android.R.attr.delay
import android.util.Log
import androidx.core.os.HandlerCompat.postDelayed
import androidx.core.os.HandlerCompat.postDelayed
import kotlinx.android.synthetic.main.activity_game.*





class GameActivity : AppCompatActivity() {
    private lateinit var sonAnimation: AnimationDrawable
    private lateinit var fatherAnimation: AnimationDrawable
    var randomValues : Long = 0

    override fun onCreate(savedInstanceState: Bundle?) {
       
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_game)

        val sonImage = findViewById<ImageView>(R.id.sonid).apply {
            setBackgroundResource(R.drawable.son)
            sonAnimation = background as AnimationDrawable
        }


        val fatherImage = findViewById<ImageView>(R.id.fatherid).apply {
            setBackgroundResource(R.drawable.father)
            fatherAnimation = background as AnimationDrawable
//            val toast = Toast.makeText(applicationContext, fatherAnimation.getFrame(3).toString(), Toast.LENGTH_SHORT)
//            toast.show()

        }
        


        

        startPlay.setOnClickListener {
            sonAnimation.start()
        }

        stop.setOnClickListener {
            sonAnimation.stop()
        }

        val handler = Handler()
        handler.postDelayed(object : Runnable {
            override fun run() {
                randomValues = Random.nextLong(0, 10)
                fatherAnimation.start()
                handler.postDelayed(this, (randomValues*1000)+941)
               
            }
        }, 2000)

        val handler1 = Handler()
        handler1.postDelayed(object : Runnable {
            override fun run() {
                fatherAnimation.stop()
                handler1.postDelayed(this, (randomValues*1000)+940)
                
            }
        }, 2940)
        
    }
    
}
