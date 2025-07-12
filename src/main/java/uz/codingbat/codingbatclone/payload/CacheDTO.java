package uz.codingbat.codingbatclone.payload;

import lombok.Builder;
import lombok.Data;
import uz.codingbat.codingbatclone.entity.Problem;
import uz.codingbat.codingbatclone.entity.enums.SolveStatus;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;


@Data
@Builder
public class CacheDTO {
    private String code;
    private SolveStatus status;
}


