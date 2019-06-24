package com.lumbermill.b_eater

import android.graphics.drawable.AnimationDrawable
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.widget.ImageView
import android.widget.Toast
import kotlin.random.Random
import android.media.MediaPlayer
import kotlinx.android.synthetic.main.activity_game.*





class GameActivity : AppCompatActivity() {
    private lateinit var sonAnimation: AnimationDrawable
    private lateinit var fatherAnimation: AnimationDrawable
    var randomValues : Long = 0
    var mediaPlayer: MediaPlayer? = null

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

        val h = Handler()
        h.postDelayed(object : Runnable {
            var score = 0
            override fun run() {
                if(sonAnimation.current == sonAnimation.getFrame(2) && fatherAnimation.current == fatherAnimation.getFrame(2)){
                    sonAnimation.stop()
                    fatherAnimation.stop()
                    val toast = Toast.makeText(applicationContext, score.toString(), Toast.LENGTH_SHORT)
                    toast.show()
                }
                if(sonAnimation.current == sonAnimation.getFrame(1)){
                    score = score+1
                }
                h.postDelayed(this, 235)
            }
        }, 235)

        stop.setOnClickListener {
            sonAnimation.stop()
            var score = 0
        }
        val handler = Handler()
        handler.postDelayed(object : Runnable {
            override fun run() {
                randomValues = Random.nextLong(0, 10)
                fatherAnimation.start()
                handler.postDelayed(this, (randomValues*1000)+940)
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
