function NumberOfProductForEachSplit = GEChangePercentageOfWorkForEachSplit(x,model)

    NumberOfProductForEachSplit = x.NumberOfProductForEachSplit;
    
    RandSelectJob = randperm(model.NumberOfJobs,1);
    
    while sum(model.OmittedJobs == RandSelectJob)
        
        RandSelectJob = randperm(model.NumberOfJobs,1);
        
    end
    
    JobSplits = x.NumberOfProductForEachSplit{RandSelectJob};
    
    SplitOrder = randperm(size(JobSplits,2));
    
    JobSplits = JobSplits(SplitOrder);
    
    NumberOfProductForEachSplit{RandSelectJob} = JobSplits;
    
%     disp(x.NumberOfProductForEachSplit{RandSelectJob});
%     
%     disp(NumberOfProductForEachSplit{RandSelectJob});

end