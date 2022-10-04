using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class Generador : MonoBehaviour
{
    public Transform jugador;
    public GameObject obstaculos;
    private int carril;
    private int distancia = 45;
    private float contador = 1.0f;
    private float currentTimer;
    // Start is called before the first frame update
    private void Start()
    {
        currentTimer = Time.time;
    }

    // Update is called once per frame
    void Update()
    {
        if (Time.time - currentTimer >= contador)
        {
            Aparece();
            currentTimer = Time.time;
        }
    }
    void Aparece()
    {
        carril = Random.Range(0, 5);
        switch (carril)
        {
            case 0:
                Instantiate(obstaculos, new Vector3(45, jugador.position.y, jugador.position.z + distancia), Quaternion.identity);
                break;
            case 1:
                Instantiate(obstaculos, new Vector3(47.5f, jugador.position.y, jugador.position.z + distancia), Quaternion.identity);
                break;
            case 2:
                Instantiate(obstaculos, new Vector3(50, jugador.position.y, jugador.position.z + distancia), Quaternion.identity);
                break;
            case 3:
                Instantiate(obstaculos, new Vector3(45, jugador.position.y, jugador.position.z + distancia), Quaternion.identity);
                Instantiate(obstaculos, new Vector3(47.5f, jugador.position.y, jugador.position.z + distancia), Quaternion.identity);
                break;
            case 4:
                Instantiate(obstaculos, new Vector3(45, jugador.position.y, jugador.position.z + distancia), Quaternion.identity);
                Instantiate(obstaculos, new Vector3(50f, jugador.position.y, jugador.position.z + distancia), Quaternion.identity);
                break;
            default:
                Instantiate(obstaculos, new Vector3(50, jugador.position.y, jugador.position.z + distancia), Quaternion.identity);
                Instantiate(obstaculos, new Vector3(47.5f, jugador.position.y, jugador.position.z + distancia), Quaternion.identity);
                break;
        }
      
    }
  
}
