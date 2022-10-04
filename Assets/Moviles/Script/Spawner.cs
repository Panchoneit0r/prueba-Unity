using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class Spawner : MonoBehaviour
{
    public GameObject camino;
    public Transform SpawPoint;
    private void OnTriggerEnter( Collider _other) {
        Instantiate(camino,SpawPoint.position,Quaternion.identity);
        StartCoroutine(Desaparece());
    }

    IEnumerator Desaparece()
    {
        yield return new WaitForSeconds(6);
        Destroy(camino);
    }
    
}
