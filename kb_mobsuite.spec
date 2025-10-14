module kb_mobsuite {

    typedef string workspace_name;
    typedef string data_obj_ref;

    typedef structure {
        workspace_name workspace_name;
        data_obj_ref   assembly_ref;
        string         sample_id;
        data_obj_ref   user_filter_fasta_ref;
        data_obj_ref   closed_genomes_fasta_ref;
        int            threads;
        int            emit_plasmid_assembly;
    } MOBReconParams;

    typedef structure {
        string       report_name;
        string       report_ref;
        data_obj_ref plasmid_assembly_ref;
    } MOBReconResult;

    typedef structure {
        workspace_name workspace_name;
        data_obj_ref   fasta_ref;
        string         sample_id;
        int            multi;
        int            threads;
        int            emit_mge_report;
    } MOBTyperParams;

    typedef structure {
        string report_name;
        string report_ref;
    } MOBTyperResult;

    typedef structure {
        workspace_name workspace_name;
        string         mode;
        data_obj_ref   plasmids_assembly_ref;
        string         mobtyper_report_staging_path;
        string         host_taxonomy_staging_path;
        string         existing_clusters_staging_path;
        string         existing_sequences_fasta_staging_path;
        string         sample_id;
    } MOBClusterParams;

    typedef structure {
        string report_name;
        string report_ref;
    } MOBClusterResult;

    typedef list<data_obj_ref> AssemblyRefList;

    typedef structure {
        workspace_name  workspace_name;
        data_obj_ref    assembly_set_ref;
        AssemblyRefList assembly_refs;
        string          sample_id_prefix;
        data_obj_ref    user_filter_fasta_ref;
        data_obj_ref    closed_genomes_fasta_ref;
        int             threads;
        int             emit_plasmid_assembly;
    } MOBReconBatchParams;

    typedef structure {
        string          report_name;
        string          report_ref;
        AssemblyRefList plasmid_assembly_refs;
    } MOBReconBatchResult;

    funcdef run_mob_recon_app(MOBReconParams params) returns (MOBReconResult);
    funcdef run_mob_typer_app(MOBTyperParams params) returns (MOBTyperResult);
    funcdef run_mob_cluster_app(MOBClusterParams params) returns (MOBClusterResult);
    funcdef run_mob_recon_batch_app(MOBReconBatchParams params) returns (MOBReconBatchResult);
}
;
