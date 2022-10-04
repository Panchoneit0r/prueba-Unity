using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Despawn : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(Desaparece());
    }

    // Update is called once per frame
    IEnumerator Desaparece()
    {
        yield return new WaitForSeconds(6);
        Destroy(gameObject);
    }
    
}
